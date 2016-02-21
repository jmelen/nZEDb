<?php

use nzedb\Category;
use nzedb\RSS;
use nzedb\db\Settings;
use nzedb\utility\Misc;

$category = new Category(['Settings' => $page->settings]);
$rss = new RSS(['Settings' => $page->settings]);

// If no content id provided then show user the rss selection page.
if (!isset($_GET["t"]) && !isset($_GET["show"]) && !isset($_GET["anidb"])) {
	// User has to either be logged in, or using rsskey.
	if (!$page->users->isLoggedIn()) {
		if ($page->settings->getSetting('registerstatus') != Settings::REGISTER_STATUS_API_ONLY) {
			Misc::showApiError(100);
		} else {
			header("Location: " . $page->settings->getSetting('code'));
		}
	}

	$page->title = "Rss Info";
	$page->meta_title = "Rss Nzb Info";
	$page->meta_keywords = "view,nzb,description,details,rss,atom";
	$page->meta_description = "View information about nZEDb RSS Feeds.";

	$firstShow = $rss->getFirstInstance('id', 'videos');
	$firstAni = $rss->getFirstInstance('anidbid', 'releases');

	if (isset($firstShow['id'])) {
		$page->smarty->assign('show', $firstShow['id']);
	} else {
		$page->smarty->assign('show', 1);
	}

	if (isset($firstAni['anidb'])) {
		$page->smarty->assign('anidb', $firstAni['id']);
	} else {
		$page->smarty->assign('anidb', 1);
	}

	$page->smarty->assign([
			'categorylist'       => $category->getCategories(true, $page->userdata["categoryexclusions"]),
			'parentcategorylist' => $category->getForMenu($page->userdata["categoryexclusions"])
		]
	);

	$page->content = $page->smarty->fetch('rssdesc.tpl');
	$page->render();
} else {
	$rssToken = $uid = -1;
	// User requested a feed, ensure either logged in or passing a valid token.
	if ($page->users->isLoggedIn()) {
		$uid = $page->userdata["id"];
		$rssToken = $page->userdata["rsstoken"];
		$maxRequests = $page->userdata['apirequests'];
	} else {
		if ($page->settings->getSetting('registerstatus') == Settings::REGISTER_STATUS_API_ONLY) {
			$res = $page->users->getById(0);
		} else {
			if (!isset($_GET["i"]) || !isset($_GET["r"])) {
				Misc::showApiError(100, 'Both the User ID and API key are required for viewing the RSS!');
			}

			$res = $page->users->getByIdAndRssToken($_GET["i"], $_GET["r"]);
		}

		if (!$res) {
			Misc::showApiError(100);
		}

		$uid = $res["id"];
		$rssToken = $res['rsstoken'];
		$maxRequests = $res['apirequests'];
		$username = $res['username'];

		if ($page->users->isDisabled($username)) {
			Misc::showApiError(101);
		}
	}

	if ($page->users->getApiRequests($uid) > $maxRequests) {
		Misc::showApiError(500, 'You have reached your daily limit for API requests!');
	} else {
		$page->users->addApiRequest($uid, $_SERVER['REQUEST_URI']);
	}
	// Valid or logged in user, get them the requested feed.

	$userShow = $userAnidb = -1;
	if (isset($_GET["show"])) {
		$userShow = ($_GET["show"] == 0 ? -1 : $_GET["show"] + 0);
	} elseif (isset($_GET["anidb"])) {
		$userAnidb = ($_GET["anidb"] == 0 ? -1 : $_GET["anidb"] + 0);
	}

	$userCat = (isset($_GET['t']) ? ($_GET['t'] == 0 ? -1 : $_GET['t']) : -1);
	$userNum = (isset($_GET["num"]) && is_numeric($_GET['num']) ? abs($_GET['num']) : 100);
	$userAirDate = (isset($_GET["airdate"]) && is_numeric($_GET['airdate']) ? abs($_GET["airdate"]) : -1);

	$page->smarty->assign([
			'dl'       => (isset($_GET['dl']) && $_GET['dl'] == '1' ? '1' : '0'),
			'del'      => (isset($_GET['del']) && $_GET['del'] == '1' ? '1' : '0'),
			'uid'      => $uid,
			'rsstoken' => $rssToken
		]
	);

	if ($userCat == -3) {
		$relData = $rss->getShowsRss($userNum, $uid, $page->users->getCategoryExclusion($uid), $userAirDate);
	} elseif ($userCat == -4) {
		$relData = $rss->getMyMoviesRss($userNum, $uid, $page->users->getCategoryExclusion($uid));
	} else {
		$relData = $rss->getRss(explode(',', $userCat), $userNum, $userShow, $userAnidb, $uid, $userAirDate);
	}

	$page->smarty->assign('releases', $relData);
	$response = trim($page->smarty->fetch('rss.tpl'));
	header("Content-type: text/xml");
	header('Content-Length: ' . strlen($response) );
	echo $response;
}
