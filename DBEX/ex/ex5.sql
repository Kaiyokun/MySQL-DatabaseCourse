CALL sp_Offset( 'Supplier', Rand() * CountRows( 'Supplier' ), 'Credit', @Credit );
SELECT @Credit;
