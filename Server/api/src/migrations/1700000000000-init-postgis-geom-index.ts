import { MigrationInterface, QueryRunner } from "typeorm";

export class InitPostgisGeomIndex1700000000000 implements MigrationInterface {
    name = 'InitPostgisGeomIndex1700000000000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Always wrap PostGIS operations in try-catch to prevent migration failure
        try {
            // First, try to check if PostGIS extension is available
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
            
            // If PostGIS is not available, skip all PostGIS operations
            if (!postgisAvailable) {
                console.warn('⚠️  PostGIS extension not available, skipping geom column creation.')
                console.warn('The app will use fallback lng/lat queries. To enable PostGIS:')
                console.warn('1. Add PostGIS extension in Railway Web UI (Database → Extensions)')
                console.warn('2. Then run: npm run migration:run')
                // Return early - migration completes successfully without PostGIS
                return
            }

            // PostGIS appears to be available, try to create it
            // But wrap in try-catch because creation might still fail
            try {
                await queryRunner.query(`CREATE EXTENSION IF NOT EXISTS postgis`)
                console.log('✅ PostGIS extension created successfully')
            } catch (error: any) {
                // Even if available check passed, creation might fail
                console.warn('⚠️  Failed to create PostGIS extension:', error.message)
                console.warn('Skipping PostGIS-related operations. App will use fallback queries.')
                return // Exit early, don't try to create columns
            }
            
            // If we get here, PostGIS was created successfully
            // Now try to create the geometry column and index
            try {
                await queryRunner.query(`ALTER TABLE IF EXISTS "venue" ADD COLUMN IF NOT EXISTS "geom" geometry(Point,4326)`)
                await queryRunner.query(`CREATE INDEX IF NOT EXISTS idx_venue_geom ON "venue" USING GIST ("geom")`)
                console.log('✅ PostGIS geom column and index created successfully')
            } catch (error: any) {
                console.warn('⚠️  Failed to create geom column or index:', error.message)
                console.warn('App will use fallback lng/lat queries.')
                // Don't throw - migration completes successfully
            }
        } catch (error: any) {
            // Catch-all: if anything goes wrong, log and continue
            console.warn('⚠️  PostGIS migration encountered an error, but continuing:', error.message)
            console.warn('App will use fallback lng/lat queries.')
            // Don't throw - allow migration to complete successfully
        }
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP INDEX IF EXISTS idx_venue_geom`)
        // keep extension
    }
}


