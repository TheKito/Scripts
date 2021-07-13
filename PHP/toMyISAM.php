<?php
  $cnn = mysqli_connect('127.0.0.1','root','');
  
  $sql = "SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE ENGINE = 'InnoDB'";
  $rs = $cnn->query($sql);

  $cnn->query('SET foreign_key_checks = 0;');

    while($row = $rs->fetch_assoc())
    {
        $shm = $row['TABLE_SCHEMA'];
        $tbl = $row['TABLE_NAME'];
        
        $sql = "ALTER TABLE `$shm`.`$tbl` ENGINE=MyISAM";
        $cnn->query($sql);
    }

    $cnn->query('SET foreign_key_checks = 1;');
