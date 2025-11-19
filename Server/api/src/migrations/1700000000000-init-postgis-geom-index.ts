import { MigrationInterface, QueryRunner } from "typeorm";

export class InitPostgisGeomIndex1700000000000 implements MigrationInterface {
    name = 'InitPostgisGeomIndex1700000000000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE EXTENSION IF NOT EXISTS postgis`)
        // ensure column exists; if not, add
        await queryRunner.query(`ALTER TABLE IF EXISTS "venue" ADD COLUMN IF NOT EXISTS "geom" geometry(Point,4326)`)
        await queryRunner.query(`CREATE INDEX IF NOT EXISTS idx_venue_geom ON "venue" USING GIST ("geom")`)
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP INDEX IF EXISTS idx_venue_geom`)
        // keep extension
    }
}


