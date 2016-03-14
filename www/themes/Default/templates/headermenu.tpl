<div id="menucontainer">
	<div id="menusearchlink">
		<form id="headsearch_form" action="{$smarty.const.WWW_TOP}/search/" method="get">

			<div class="gobutton" title="Submit search"><input id="headsearch_go"
						type="submit"
						value=""
						tabindex="3" /></div>

			<label style="display:none;" for="headcat">Search Category</label>
			<select id="headcat" name="t" tabindex="2" style="height: 1.5em;font-size: 1em">
				<option class="grouping" value="-1">All</option>
				{foreach $parentcatlist as $parentcat}
					<option {if $header_menu_cat==$parentcat.id}selected="selected"{/if}
							class="grouping"
							value="{$parentcat.id}">{$parentcat.title}</option>
					{foreach $parentcat.subcatlist as $subcat}
						<option {if $header_menu_cat==$subcat.id}selected="selected"{/if}
								value="{$subcat.id}">&nbsp;&nbsp;{$subcat.title}</option>
					{/foreach}
				{/foreach}
			</select>

			<label style="display:none;" for="headsearch">Search Text</label>
			<input id="headsearch"
					name="search"
					value="{if $header_menu_search == ""}Enter	keywords{else}{$header_menu_search|escape:"htmlall"}{/if}"
					style="width:25em;"
					type="text"
					tabindex="1" />

		</form>
	</div>
	<div id="menulink">
		<ul>
			{if isset($userdata)}
				{foreach $parentcatlist as $parentcat}
					{if $parentcat.id == {$catClass::GAME_ROOT} && $userdata.consoleview == "1" && $site->lookupgames == "1"}
						<li><a title="Browse All {$parentcat.title}"
									href="{$smarty.const.WWW_TOP}/console">{$parentcat.title}</a>
							<ul>
								{foreach $parentcat.subcatlist as $subcat}
									<li><a title="Browse {$subcat.title}"
												href="{$smarty.const.WWW_TOP}/console?t={$subcat.id}">{$subcat.title}</a>
									</li>
								{/foreach}
							</ul>
						</li>
					{/if}
					{if $parentcat.id == {$catClass::MOVIE_ROOT} && $userdata.movieview == "1" && $site->lookupimdb > "0"}
						<li><a title="Browse All {$parentcat.title}"
									href="{$smarty.const.WWW_TOP}/movies">{$parentcat.title}</a>
							<ul>
								{foreach $parentcat.subcatlist as $subcat}
									<li><a title="Browse {$subcat.title}"
												href="{$smarty.const.WWW_TOP}/movies?t={$subcat.id}">{$subcat.title}</a>
									</li>
								{/foreach}
							</ul>
						</li>
					{/if}
					{if ($parentcat.id == {$catClass::MUSIC_ROOT} && $userdata.musicview == "1") && $site->lookupmusic == "1"}
						<li><a title="Browse All {$parentcat.title}"
									href="{$smarty.const.WWW_TOP}/music">{$parentcat.title}</a>
							<ul>
								{foreach $parentcat.subcatlist as $subcat}
									{if $subcat.id == {$catClass::MUSIC_AUDIOBOOK}}
										<li><a title="Browse {$subcat.title}"
													href="{$smarty.const.WWW_TOP}/browse?t={$subcat.id}">{$subcat.title}</a>
										</li>
									{else}
										<li><a title="Browse {$subcat.title}"
													href="{$smarty.const.WWW_TOP}/music?t={$subcat.id}">{$subcat.title}</a>
										</li>
									{/if}
								{/foreach}
							</ul>
						</li>
					{/if}
					{if ($parentcat.id == {$catClass::PC_ROOT} && $userdata.gameview == "1")}
						<li><a title="Browse All {$parentcat.title}"
									href="{$smarty.const.WWW_TOP}/games">{$parentcat.title}</a>
							<ul>
								{foreach $parentcat.subcatlist as $subcat}
									{if $subcat.id == {$catClass::PC_GAMES}}
										<li><a title="Browse {$subcat.title}"
													href="{$smarty.const.WWW_TOP}/games">{$subcat.title}</a>
										</li>
									{else}
										<li><a title="Browse {$subcat.title}"
													href="{$smarty.const.WWW_TOP}/browse?t={$subcat.id}">{$subcat.title}</a>
										</li>
									{/if}
								{/foreach}
							</ul>
						</li>
					{/if}
					{if $parentcat.id == {$catClass::TV_ROOT}}
						<li><a title="Browse All {$parentcat.title}"
									href="{$smarty.const.WWW_TOP}/series">{$parentcat.title}</a>
							<ul>
								{foreach $parentcat.subcatlist as $subcat}
									<li><a title="Browse {$subcat.title}"
												href="{$smarty.const.WWW_TOP}/browse?t={$subcat.id}">{$subcat.title}</a>
									</li>
								{/foreach}
							</ul>
						</li>
					{/if}
					{if ($parentcat.id == {$catClass::XXX_ROOT} && $userdata.xxxview == "1" && $site->lookupxxx == "1")}
						<li class="dropdown">
							<a title="Browse All {$parentcat.title}"
									href="{$smarty.const.WWW_TOP}/xxx">{$parentcat.title}</a>
							<ul>
								{foreach $parentcat.subcatlist as $subcat}
									{if $subcat.id == {$catClass::XXX_DVD} OR {$catClass::XXX_WMV} OR {$catClass::XXX_XVID} OR {$catClass::XXX_X264}}
										<li><a title="Browse {$subcat.title}"
													href="{$smarty.const.WWW_TOP}/xxx?t={$subcat.id}">{$subcat.title}</a>
										</li>
									{else}
										<li><a title="Browse {$subcat.title}"
													href="{$smarty.const.WWW_TOP}/browse?t={$subcat.id}">{$subcat.title}</a>
										</li>
									{/if}
								{/foreach}
							</ul>
						</li>
					{/if}
					{if ($parentcat.id == {$catClass::BOOKS_ROOT} && $userdata.bookview == "1") &&
					$site->lookupbooks == "1"}
						<li><a title="Browse All {$parentcat.title}"
									href="{$smarty.const.WWW_TOP}/books">{$parentcat.title}</a>
							<ul>
								{foreach $parentcat.subcatlist as $subcat}
									{if $subcat.id == {$catClass::BOOKS_UNKNOWN}}
										<li><a title="Browse {$subcat.title}"
													href="{$smarty.const.WWW_TOP}/books">{$subcat.title}</a>
										</li>
									{else}
										<li><a title="Browse {$subcat.title}"
													href="{$smarty.const.WWW_TOP}/browse?t={$subcat.id}">{$subcat.title}</a>
										</li>
									{/if}
								{/foreach}
							</ul>
						</li>
					{/if}
				{/foreach}
				<li>
					<a title="Miscellaneous" href="#">Other</a>
					<ul>
						<hr>
						<li><a href="/browse?t={$catClass::OTHER_MISC}">Misc</a></li>
						<li><a href="/browse?t={$catClass::OTHER_HASHED}">Hashed</a></li>
					</ul>
				</li>
			{/if}
			<li><a title="Browse All" href="{$smarty.const.WWW_TOP}/browse">All</a>
				<ul>
					<li><a title="Browse Groups"
								href="{$smarty.const.WWW_TOP}/browsegroup">Groups</a></li>
				</ul>
			</li>
		</ul>
	</div>
</div>
