<?php
	$STORAGE_DATABASE = '/Storage/BLK050NAS002DAT001/HistoryStorage';
	$STORAGE_SOURCE = '/Storage/BLK050NAS002DAT001/History';

	process($STORAGE_DATABASE,$STORAGE_SOURCE);

	function process($storageDatabase,$storageSource)
	{
		foreach(scandir($storageSource) as $name)
		{
			if($name === '.')
				continue;

			if($name === '..')
				continue;

			$subPath = $storageSource . '/' . $name;

			if(is_dir($subPath))
				process($storageDatabase,$subPath);

			if(is_file($subPath))
				processFile($storageDatabase,$subPath);
		}
	}

	function getFileUID($file)
	{
		if(!is_readable($file))
			return;

		return strtoupper(sha1_file($file).'X'.md5_file($file).'X'.filesize($file));
	}

	function getPathFromUID($uid)
	{
		$chars = array();
		foreach(str_split(strtoupper($uid)) as $char)
		{
			if(in_array($char,$chars))
				continue;

			$chars[] = $char;

		}

		if(count($chars) % 2 !=0)
			array_pop($chars);

		$key = implode('',$chars);

		return implode ('/',str_split($key,2));
	}

	function getFileDatabasePath($storageDatabase,$file)
	{
		$fileUID = getFileUID($file);

		if($fileUID===null)
			return;

		$path = $storageDatabase.'/'.getPathFromUID($fileUID);

		if(!is_dir($path))
			mkdir($path,0777,true);

		return $path.'/'.$fileUID;
	}


	function checkValidDataPath($storageDatabase,$dataPath)
	{
		$dataPathCheck = getFileDatabasePath($storageDatabase,$dataPath);

                if($dataPath!=$dataPathCheck)
                {
                	rename($dataPath,$dataPathCheck);
                        return false;
                }

		return true;
	}


	function compareFiles($file_a, $file_b)
	{
		if (filesize($file_a) != filesize($file_b))
			return false;

		$fp_a = fopen($file_a, 'rb');
		$fp_b = fopen($file_b, 'rb');

		do
		{
			$b_a = fread($fp_a, 1024*1024);
			$b_b = fread($fp_b, 1024*1024);

			if ($b_a !== $b_b)
			{
				fclose($fp_a);
				fclose($fp_b);
				return false;
			}

		} while(strlen($b_a)>0 && strlen($b_b)>0);

		fclose($fp_a);
		fclose($fp_b);

		return true;
	}

	function replaceFileForLink($linkSource,$linkDest)
	{
		$tmp = uniqid($linkDest);

		if(!rename($linkDest,$tmp))
			return;

		if(!link($linkSource,$linkDest))
		{
			rename($tmp,$linkDest);
			return;
		}

		unlink($tmp);

		passthru('ls -l "'.$linkDest.'"');
	}

	function processFile($storageDatabase,$file)
	{
		$dataPath = getFileDatabasePath($storageDatabase,$file);

		if($dataPath===null)
			return;

		if(!file_exists($dataPath))
		{
			copy($file,$dataPath);
			chmod($file,0444);

			return;
		}


		if(!checkValidDataPath($storageDatabase,$dataPath))
			return;


		if(fileinode($file)===fileinode($dataPath))
			return;

		if(!compareFiles($file,$dataPath))
		{
			print_r(array('Compare','Error',$file,$dataPath));
			return;
		}

		if(!is_writeable($file))
			return;

		replaceFileForLink($dataPath,$file);

	}

