import { neon } from "@neondatabase/serverless";
import { env } from "./env";

/**
 * Neon PostgreSQL connection.
 * DATABASE_URL is read from the server environment.
 */
export const sql = neon(env.databaseUrl);
