import { MigrationInterface, QueryRunner } from "typeorm";

export class InitPostgisGeomIndex1700000000000 implements MigrationInterface {
    name = 'InitPostgisGeomIndex1700000000000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Check if PostGIS extension is available BEFORE starting any transaction operations
        let postgisAvailable = false
        try {
            const extensionCheck = await queryRunner.query(`
                SELECT EXISTS(
                    SELECT 1 FROM pg_available_extensions WHERE name = 'postgis'
                ) as available
            `)
            postgisAvailable = extensionCheck[0]?.available === true
        } catch (error: any) {
            console.warn('⚠️  Could not check PostGIS availability:', error.message)
            postgisAvailable = false
        }
        
        if (!postgisAvailable) {
            console.warn('⚠️  PostGIS extension not available, skipping geom column creation.')
            console.warn('The app will use fallback lng/lat queries. To enable PostGIS:')
            console.warn('1. Add PostGIS extension in Railway Web UI (Database → Extensions)')
            console.warn('2. Then run: npm run migration:run')
            // Return early - migration completes successfully without PostGIS
            return
        }

        // PostGIS is available, proceed with creating extension and columns
        try {
            // Create PostGIS extension (this might still fail even if available check passed)
            await queryRunner.query(`CREATE EXTENSION IF NOT EXISTS postgis`)
            
            // ensure column exists; if not, add
            await queryRunner.query(`ALTER TABLE IF EXISTS "venue" ADD COLUMN IF NOT EXISTS "geom" geometry(Point,4326)`)
            await queryRunner.query(`CREATE INDEX IF NOT EXISTS idx_venue_geom ON "venue" USING GIST ("geom")`)
            
            console.log('✅ PostGIS extension and geom column created successfully')
        } catch (error: any) {
            // If PostGIS creation fails, log warning but don't fail the migration
            console.warn('⚠️  Failed to create PostGIS extension or columns:', error.message)
            console.warn('Skipping PostGIS-related operations. App will use fallback queries.')
            // Don't throw - allow migration to complete successfully
        }
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP INDEX IF EXISTS idx_venue_geom`)
        // keep extension
    }
}


