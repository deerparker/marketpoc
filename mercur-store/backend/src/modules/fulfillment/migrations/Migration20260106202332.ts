import { Migration } from "@medusajs/framework/mikro-orm/migrations";

export class Migration20260106202332 extends Migration {

  override async up(): Promise<void> {
    this.addSql(`create table if not exists "fulfillment_journey" ("id" text not null, "type" text check ("type" in ('shopify', 'form', 'voucher', 'whatsapp', 'manual')) not null default 'manual', "config" jsonb null, "seller_id" text not null, "created_at" timestamptz not null default now(), "updated_at" timestamptz not null default now(), "deleted_at" timestamptz null, constraint "fulfillment_journey_pkey" primary key ("id"));`);
    this.addSql(`CREATE INDEX IF NOT EXISTS "IDX_fulfillment_journey_deleted_at" ON "fulfillment_journey" ("deleted_at") WHERE deleted_at IS NULL;`);
  }

  override async down(): Promise<void> {
    this.addSql(`drop table if exists "fulfillment_journey" cascade;`);
  }

}
