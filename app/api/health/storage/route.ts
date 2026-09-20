import { sql } from "@/lib/db";
import { checkR2Connection } from "@/lib/r2";

export async function GET() {
  const checks: Record<string, string> = {};

  try {
    await sql`select 1 as ok`;
    checks.neon = "ok";
  } catch (error) {
    console.error("Neon health check failed:", error);
    checks.neon = "error";
  }

  try {
    await checkR2Connection();
    checks.r2 = "ok";
  } catch (error) {
    console.error("R2 health check failed:", error);
    checks.r2 = "error";
  }

  const ok = checks.neon === "ok" && checks.r2 === "ok";

  return Response.json(
    { ok, checks },
    { status: ok ? 200 : 503 }
  );
}
