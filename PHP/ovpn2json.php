<?php

$files = array(
    '/var/log/openvpn-statusTCPv4.log',
    '/var/log/openvpn-statusUDPv4.log',
    '/var/log/openvpn-statusTCPv6.log',
    '/var/log/openvpn-statusUDPv6.log',
);
$json = '/var/log/openvpn.json';

$section = null;
$peers = array();

foreach (scandir('/var/log/') as $file)
{
    if ($file == '.')
        continue;

    if ($file == '..')
        continue;

    if (strpos($file, 'openvpn-status') === FALSE)
        continue;

    if (strpos($file, '.log') === FALSE)
        continue;

    foreach (explode("\n", str_replace("\r", "\n", file_get_contents('/var/log/' . $file))) as $line)
    {
        if ($line == '')
            continue;

        if (strpos($line, 'END') !== FALSE)
        {
            $section = null;
            continue;
        }
        elseif (strpos($line, 'CLIENT LIST') !== FALSE)
        {
            $section = 'CLIENTS';
            continue;
        }
        elseif (strpos($line, 'ROUTING TABLE') !== FALSE)
        {
            $section = 'ROUTES';
            continue;
        }
        elseif (strpos($line, 'GLOBAL STATS') !== FALSE)
        {
            $section = 'STATS';
            continue;
        }

        if ($section === null)
            continue;

        $line = explode(',', $line);

        if ($section == 'CLIENTS')
        {
            if (count($line) != 5)
                continue;

            $virtual_address = null;
            $common_name = $line[0];
            $real_address = $line[1];
        }
        elseif ($section == 'ROUTES')
        {
            if (count($line) != 4)
                continue;

            $virtual_address = $line[0];
            $common_name = $line[1];
            $real_address = $line[2];
        }
        elseif ($section == 'STATS')
        {
            continue;
        }


        $_ = explode(':', $real_address);
        if (!filter_var($_[0], FILTER_VALIDATE_IP))
            continue;

        if (!isset($peers[$real_address]))
            $peers[$real_address] = array();

        $peer = $peers[$real_address];

        $peer['common_name'] = $common_name;

        if (!isset($peer['clients']))
            $peer['clients'] = array();

        if (!isset($peer['networks']))
            $peer['networks'] = array();

        if (strpos($virtual_address, '/') !== FALSE)
        {
            $networks = $peer['networks'];

            $_ = explode('/', $virtual_address, 2);

            if (count($_) == 2 && filter_var($_[0], FILTER_VALIDATE_IP) && is_numeric($_[1]) && $_[1] <= 64 && $_[1] >= 0 && !in_array($virtual_address, $networks))
                $networks[] = $virtual_address;

            $peer['networks'] = $networks;
        }
        elseif (strpos($virtual_address, 'C') !== FALSE)
        {
            $clients = $peer['clients'];

            $_ = explode('C', $virtual_address, 2);

            if (filter_var($_[0], FILTER_VALIDATE_IP) && !in_array($_[0], $clients))
                $clients[] = $_[0];

            $peer['clients'] = $clients;
        }
        elseif (filter_var($virtual_address, FILTER_VALIDATE_IP))
        {
            $peer['next_hop'] = $virtual_address;
        }
        elseif ($virtual_address !== null)
        {
            print_r($line);
        }


        $peers[$real_address] = $peer;
    }
}

$json_data = json_encode($peers);

if (!file_exists($json) || file_get_contents($json) != $json_data)
    file_put_contents($json, $json_data);
