<?php

declare(strict_types=1);

class UID2Path
{

        public static function getPath(string $uid) : string 
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

                return implode (DIRECTORY_SEPARATOR ,str_split($key,2));
        }


}
