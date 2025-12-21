import { MigrationInterface, QueryRunner } from "typeorm";

export class InitPostgisGeomIndex1700000000000 implements MigrationInterface {
    name = 'InitPostgisGeomIndex1700000000000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Always wrap PostGIS operations in try-catch to prevent migration failure
        // Railway PostgreSQL may not have PostGIS installed, so we gracefully skip it
        
        // First, check if PostGIS extension is already installed
        let postgisInstalled = false
        try {
            const checkResult = await queryRunner.query(`
                SELECT EXISTS(
                    SELECT 1 FROM pg_extension WHERE extname = 'postgis'
                ) as installed
            `)
            postgisInstalled = checkResult[0]?.installed === true
        } catch (error: any) {
            // If check fails, assume not installed
            postgisInstalled = false
        }
        
        // If not installed, try to create it (but catch errors gracefully)
        if (!postgisInstalled) {
            try {
                await queryRunner.query(`CREATE EXTENSION IF NOT EXISTS postgis`)
                console.log('✅ PostGIS extension created successfully')
            } catch (error: any) {
                // PostGIS is not available or cannot be created
                // This is OK - the app will use fallback lng/lat queries
                // Note: PostgreSQL will still log an error, but migration succeeds
                console.warn('⚠️  PostGIS extension not available, skipping PostGIS setup.')
                console.warn('   The app will use fallback lng/lat queries (which work fine).')
                console.warn('   To enable PostGIS on Railway:')
                console.warn('   1. Go to Railway Dashboard → Your Database → Extensions')
                console.warn('   2. Add "postgis" extension')
                console.warn('   3. Then run: npm run migration:run')
                // Return early - migration completes successfully without PostGIS
                return
            }
        } else {
            console.log('✅ PostGIS extension already installed')
        }
        
        // If we get here, PostGIS was created successfully
        // Now try to create the geometry column and index
        try {
            await queryRunner.query(`ALTER TABLE IF EXISTS "venue" ADD COLUMN IF NOT EXISTS "geom" geometry(Point,4326)`)
            await queryRunner.query(`CREATE INDEX IF NOT EXISTS idx_venue_geom ON "venue" USING GIST ("geom")`)
            console.log('✅ PostGIS geom column and index created successfully')
        } catch (error: any) {
            // Even if PostGIS extension exists, column creation might fail
            console.warn('⚠️  Failed to create geom column or index:', error.message)
            console.warn('   App will use fallback lng/lat queries.')
            // Don't throw - migration completes successfully
        }
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP INDEX IF EXISTS idx_venue_geom`)
        // keep extension
    }
}


