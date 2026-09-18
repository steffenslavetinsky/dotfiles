import { isToolCallEventType, type ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { execFile } from "node:child_process";
import { homedir } from "node:os";
import { promisify } from "node:util";

const execFileAsync = promisify(execFile);

const GATE = `${homedir()}/.agent-hooks/gitui-review-gate.sh`;

// "git" (bare, rtk-prefixed or absolute), then any global options such as
// -C <path>, -c <k=v>, --git-dir=<x> or --no-pager, then the verb.
const GIT = String.raw`(^|[^\w-])git(\s+-\S+(\s+[^-\s]\S*)?)*\s+`;
const COMMIT = new RegExp(`${GIT}commit(?![\\w-])`);
const PUSH = new RegExp(`${GIT}push(?![\\w-])`);

function gitAction(command: string): "commit" | "push" | undefined {
  if (COMMIT.test(command)) return "commit";
  if (PUSH.test(command)) return "push";
  return undefined;
}

export default function (pi: ExtensionAPI) {
  pi.on("tool_call", async (event, ctx) => {
    if (!isToolCallEventType("bash", event)) return;

    const action = gitAction(event.input.command ?? "");
    if (!action) return;

    const sessionId = ctx.sessionManager.getSessionId() ?? "unknown";
    let message = "";

    try {
      await execFileAsync(GATE, [action, sessionId]);
      return;
    } catch (error) {
      const failed = error as { code?: number; stderr?: string; stdout?: string };
      if (failed.code !== 2) {
        return { block: true, reason: `GitUI review gate failed: ${failed.stderr || failed.stdout || "unknown error"}` };
      }
      message = failed.stderr || failed.stdout || `Review with gitui before git ${action}.`;
    }

    if (!ctx.hasUI) {
      return { block: true, reason: message, terminate: true };
    }

    const ok = await ctx.ui.confirm(`Review before git ${action}`, `${message}\nAllow git ${action}?`);
    if (!ok) {
      return { block: true, reason: `User denied git ${action} after GitUI review gate.`, terminate: true };
    }
  });
}
