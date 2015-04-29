SELECT
        Round( Avg( Charge ) - Rand() * 500, 2 ),
        Round( Avg( Charge ) + Rand() * 500, 2 )
FROM
        Project;
