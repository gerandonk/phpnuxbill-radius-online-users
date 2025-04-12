<?php
use Radius;

register_menu("Radius Online Users", true, "radon_users", 'RADIUS', '');

function radon_users()
{
    global $ui;
    _admin();
    $ui->assign('_title', 'Radius Online Users');
    $ui->assign('_system_menu', 'radius');
    $admin = Admin::_info();
    $ui->assign('_admin', $admin);

    $useron = ORM::for_table('radacct')
        ->where_raw("acctstoptime IS NULL")
        ->order_by_asc('acctsessiontime')
        ->find_many();
    
    $totalCount = ORM::for_table('radacct')
        ->where_raw("acctstoptime IS NULL")
        ->count();

    if (isset($_POST['kill'])) {
        $error = [];
        $retcode = 0;
        $coaport = 3799;
        $username = _post('username');
        $nasIp = _post('nas_ip');
        $nas = ORM::for_table('nas')->where_like('nasname', "%$nasIp%")->find_one();

        if ($nas) {
            $sharedsecret = $nas['secret'];
            $userOnline = ORM::for_table('radacct')
                ->where('username', $username)
                ->where_raw("acctstoptime IS NULL")
                ->findOne();

            if ($userOnline) {
                // Disconnect the user
                exec("echo 'User-Name=$username'|radclient {$nas['nasname']}:$coaport disconnect '$sharedsecret'", $output, $retcode);

                // Update session end time
                $userOnline['acctstoptime'] = date('Y-m-d H:i:s');
                $userOnline->save();
            } else {
                $error[] = Lang::T("Username: $username has no active session.");
                _log(Lang::T("Username: $username has no active session."));
            }
        } else {
            $error[] = Lang::T("NAS not found for IP: $nasIp.");
            _log(Lang::T("NAS not found for IP: $nasIp."));
        }
    }
	$ui->assign('error', $error);
    $ui->assign('useron', $useron);
    $ui->assign('totalCount', $totalCount);
    $ui->assign('xheader', '<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.11.3/css/jquery.dataTables.min.css">');
    $ui->display('radon.tpl');
}


// Function to format bytes into KB, MB, GB or TB
function radon_formatBytes($bytes, $precision = 2)
{
	$units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
	$bytes = max($bytes, 0);
	$pow = floor(($bytes ? log($bytes) : 0) / log(1024));
	$pow = min($pow, count($units) - 1);
	$bytes /= pow(1024, $pow);
	return round($bytes, $precision) . ' ' . $units[$pow];
}

// Convert seconds into months, days, hours, minutes, and seconds.
function radon_secondsToTimeFull($ss)
{
	$s = $ss % 60;
	$m = floor(($ss % 3600) / 60);
	$h = floor(($ss % 86400) / 3600);
	$d = floor(($ss % 2592000) / 86400);
	$M = floor($ss / 2592000);

	return "$M months, $d days, $h hours, $m minutes, $s seconds";
}

function radon_secondsToTime($inputSeconds)
{
	$secondsInAMinute = 60;
	$secondsInAnHour = 60 * $secondsInAMinute;
	$secondsInADay = 24 * $secondsInAnHour;

	// Extract days
	$days = floor($inputSeconds / $secondsInADay);

	// Extract hours
	$hourSeconds = $inputSeconds % $secondsInADay;
	$hours = floor($hourSeconds / $secondsInAnHour);

	// Extract minutes
	$minuteSeconds = $hourSeconds % $secondsInAnHour;
	$minutes = floor($minuteSeconds / $secondsInAMinute);

	// Extract the remaining seconds
	$remainingSeconds = $minuteSeconds % $secondsInAMinute;
	$seconds = ceil($remainingSeconds);

	// Format and return
	$timeParts = [];
	$sections = [
		'day' => (int) $days,
		'hour' => (int) $hours,
		'minute' => (int) $minutes,
		'second' => (int) $seconds,
	];

	foreach ($sections as $name => $value) {
		if ($value > 0) {
			$timeParts[] = $value . ' ' . $name . ($value == 1 ? '' : 's');
		}
	}

	return implode(', ', $timeParts);
}

function radon_users_cleandb()
{
	global $ui;
	_admin();
	$admin = Admin::_info();
	try {
		ORM::get_db()->exec('TRUNCATE TABLE `radacct`');
		r2(U . 'plugin/radon_users', 's', Lang::T("RADACCT table truncated successfully."));
	} catch (Exception $e) {
		r2(U . 'plugin/radon_users', 'e', Lang::T("Failed to truncate RADACCT table."));
	}
}