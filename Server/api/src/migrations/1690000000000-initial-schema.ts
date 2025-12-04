import { MigrationInterface, QueryRunner, Table, TableColumn, TableForeignKey, TableIndex } from "typeorm";

export class InitialSchema1690000000000 implements MigrationInterface {
    name = 'InitialSchema1690000000000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Create user table
        await queryRunner.createTable(
            new Table({
                name: 'user',
                columns: [
                    {
                        name: 'id',
                        type: 'int',
                        isPrimary: true,
                        isGenerated: true,
                        generationStrategy: 'increment',
                    },
                    {
                        name: 'phone',
                        type: 'varchar',
                        length: '20',
                        isUnique: true,
                    },
                    {
                        name: 'nickname',
                        type: 'varchar',
                        length: '50',
                        isNullable: true,
                    },
                    {
                        name: 'avatar',
                        type: 'varchar',
                        length: '200',
                        isNullable: true,
                    },
                    {
                        name: 'password',
                        type: 'varchar',
                        length: '100',
                    },
                    {
                        name: 'role',
                        type: 'varchar',
                        length: '20',
                        default: "'user'",
                    },
                    {
                        name: 'status',
                        type: 'varchar',
                        length: '20',
                        default: "'active'",
                    },
                    {
                        name: 'createdAt',
                        type: 'timestamptz',
                        default: 'CURRENT_TIMESTAMP',
                    },
                    {
                        name: 'updatedAt',
                        type: 'timestamptz',
                        default: 'CURRENT_TIMESTAMP',
                    },
                ],
            }),
            true
        );

        // Create venue table
        await queryRunner.createTable(
            new Table({
                name: 'venue',
                columns: [
                    {
                        name: 'id',
                        type: 'int',
                        isPrimary: true,
                        isGenerated: true,
                        generationStrategy: 'increment',
                    },
                    {
                        name: 'name',
                        type: 'varchar',
                        length: '120',
                    },
                    {
                        name: 'sportType',
                        type: 'varchar',
                        length: '20',
                    },
                    {
                        name: 'cityCode',
                        type: 'varchar',
                        length: '6',
                    },
                    {
                        name: 'address',
                        type: 'varchar',
                        length: '200',
                        isNullable: true,
                    },
                    {
                        name: 'lng',
                        type: 'double precision',
                    },
                    {
                        name: 'lat',
                        type: 'double precision',
                    },
                    {
                        name: 'priceMin',
                        type: 'int',
                        isNullable: true,
                    },
                    {
                        name: 'priceMax',
                        type: 'int',
                        isNullable: true,
                    },
                    {
                        name: 'indoor',
                        type: 'boolean',
                        isNullable: true,
                    },
                ],
            }),
            true
        );

        // Create indexes for venue
        await queryRunner.createIndex('venue', new TableIndex({
            name: 'IDX_venue_lng',
            columnNames: ['lng'],
        }));
        await queryRunner.createIndex('venue', new TableIndex({
            name: 'IDX_venue_lat',
            columnNames: ['lat'],
        }));

        // Create venue_image table
        await queryRunner.createTable(
            new Table({
                name: 'venue_image',
                columns: [
                    {
                        name: 'id',
                        type: 'int',
                        isPrimary: true,
                        isGenerated: true,
                        generationStrategy: 'increment',
                    },
                    {
                        name: 'venueId',
                        type: 'int',
                    },
                    {
                        name: 'userId',
                        type: 'int',
                    },
                    {
                        name: 'url',
                        type: 'text',
                    },
                    {
                        name: 'sort',
                        type: 'int',
                        default: 0,
                    },
                ],
            }),
            true
        );

        // Create foreign keys for venue_image
        await queryRunner.createForeignKey('venue_image', new TableForeignKey({
            columnNames: ['venueId'],
            referencedColumnNames: ['id'],
            referencedTableName: 'venue',
            onDelete: 'CASCADE',
        }));
        await queryRunner.createForeignKey('venue_image', new TableForeignKey({
            columnNames: ['userId'],
            referencedColumnNames: ['id'],
            referencedTableName: 'user',
            onDelete: 'CASCADE',
        }));
        await queryRunner.createIndex('venue_image', new TableIndex({
            name: 'IDX_venue_image_venueId',
            columnNames: ['venueId'],
        }));

        // Create review table
        await queryRunner.createTable(
            new Table({
                name: 'review',
                columns: [
                    {
                        name: 'id',
                        type: 'int',
                        isPrimary: true,
                        isGenerated: true,
                        generationStrategy: 'increment',
                    },
                    {
                        name: 'venueId',
                        type: 'int',
                    },
                    {
                        name: 'userId',
                        type: 'int',
                    },
                    {
                        name: 'rating',
                        type: 'int',
                    },
                    {
                        name: 'content',
                        type: 'text',
                    },
                    {
                        name: 'createdAt',
                        type: 'timestamptz',
                        default: 'CURRENT_TIMESTAMP',
                    },
                ],
            }),
            true
        );

        // Create foreign keys for review
        await queryRunner.createForeignKey('review', new TableForeignKey({
            columnNames: ['venueId'],
            referencedColumnNames: ['id'],
            referencedTableName: 'venue',
            onDelete: 'CASCADE',
        }));
        await queryRunner.createForeignKey('review', new TableForeignKey({
            columnNames: ['userId'],
            referencedColumnNames: ['id'],
            referencedTableName: 'user',
            onDelete: 'CASCADE',
        }));
        await queryRunner.createIndex('review', new TableIndex({
            name: 'IDX_review_venueId',
            columnNames: ['venueId'],
        }));
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.dropTable('review', true);
        await queryRunner.dropTable('venue_image', true);
        await queryRunner.dropTable('venue', true);
        await queryRunner.dropTable('user', true);
    }
}






