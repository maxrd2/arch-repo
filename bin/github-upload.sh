#!/bin/bash

gh_repo=maxrd2/arch-repo

set -e

[[ ! -f "$HOME/.github/token" ]] && echo "\e[1;31mERROR:\e[m Cannot find GitHub token." 1>&2 && exit 1
. "$HOME/.github/token"

cd "$(dirname "$0")/.."

#curl=(curl -u "maxrd2:${GITHUB_TOKEN}")
curl=(curl -H "Authorization: token ${GITHUB_TOKEN}")
api_url="https://api.github.com/repos/$gh_repo"

release_from_repo() {
	gh_is_tag=
	gh_release="$(cd "$(dirname "$0")" && git describe --exact-match 2>/dev/null)" && gh_is_tag=1
	[[ -z "$gh_release" ]] && gh_release="$(cd "$(dirname "$0")" && git branch --show-current)"
	[[ "$gh_release" = "master" ]] && gh_release="continuous"
	[[ -z "$gh_release" ]] && echo "\e[1;31mERROR:\e[m unable to figure current branch/tag."  1>&2 && exit 1
	export gh_is_tag gh_release
}

release_update() {
	local url="$api_url/releases/tags/$gh_release"
	echo -e "Getting release info from '\e[1;39m$url\e[m'..."
	"${curl[@]}" -s -XGET "${url}" | jq . >.github_release
	local id="$(jq -r .id .github_release)"
	if [[ -z "$id" || "$id" = "null" ]]; then
		# create release
		"${curl[@]}" -s "$api_url/releases" -XPOST --data '{"tag_name":"'"$gh_release"'", "name":"Latest Packages", "body":"'"$body"'", "draft":false, "prerelease":false}' >.github_release
	else
		# update release
		"${curl[@]}" -s "$api_url/releases/$id" -XPOST --data '{"tag_name":"'"$gh_release"'", "name":"Latest Packages", "body":"'"$body"'", "draft":false, "prerelease":false}' >.github_release
	fi
}

asset_exists() {
	declare -i i=0
	for asset_name in "${assets[@]}"; do
		[[ "$asset_name" = "$1" ]] && return 0
		#echo "asset[$i]: '$asset_name' != '$1'"
		i=i+1
	done
	return 1
}

assets_sync() {
	local assets=(`jq -r '.assets[].name' .github_release`)
	local upload_url="$(jq -r '.upload_url|gsub("{.*}";"")' .github_release)?name="
	
	# upload new assets
	local new_assets=()
	for pathname in "$PWD/.repo/"*.pkg.tar.xz; do
		local basename="$(basename "$pathname")"
		new_assets+=("$basename")
		
		asset_exists "$basename" && echo -e "Not uploading '\e[1;32m$basename\e[m' - already exists..." && continue
		
		local url="$upload_url$(echo "$basename" | sed -e 's!%!%25!g;s! !%20!g;s!:!%3A!g;s!+!%2B!g')"
		echo -e "Uploading '\e[1;33m$basename\e[m' to '$url'..."
		asset="$("${curl[@]}" \
			-H "Accept: application/vnd.github.manifold-preview" \
			-H "Content-Type: application/octet-stream" \
			--data-binary @$pathname \
			"$url")"
		[[ "$(echo "$asset" | jq -r .errors)" != "null" ]] && echo "$asset" | jq -C . && return 1
		local remotename="$(echo "$asset" | jq -r .name)"
		if [[ "$basename" != "$remotename" ]]; then
			echo "\e[1;31mERROR:\e[m GitHub renamed our file '$basename' to '$(echo "$asset" | jq -r .name)'..."
			echo "$asset" | jq -C .
			return 1
		fi
	done

	# upload repo
	local pathname="$PWD/.repo/maxrd2.db"
	local basename="$(basename "$pathname")"
	new_assets+=("$basename")
	local url="$upload_url$basename"
	
	declare -i i=0
	for asset_name in "${assets[@]}"; do
		[[ "$basename" = "$asset_name" ]] \
			&& echo -e "Delete old repo '\e[1;31m$asset_name\e[m'..." \
			&& "${curl[@]}" -s -XDELETE "$(jq -r '.assets['$i'].url' .github_release)" \
			&& break
		i=i+1
	done

	echo -e "Uploading repository '\e[1;33m$basename\e[m' to '$url'..."
	asset="$("${curl[@]}" \
		-H "Accept: application/vnd.github.manifold-preview" \
		-H "Content-Type: application/octet-stream" \
		--data-binary @$pathname \
		"$url")"
	[[ "$(echo "$asset" | jq -r .errors)" != "null" ]] && echo "$asset" | jq -C .

	# delete old assets
	declare -i i=0
	for asset_name in "${assets[@]}"; do
		[[ " ${new_assets[@]} " != *" $asset_name "* ]] \
			&& echo -e "Delete '\e[1;31m$asset_name\e[m'..." \
			&& "${curl[@]}" -s -XDELETE "$(jq -r '.assets['$i'].url' .github_release)"
		i=i+1
	done
}

gh_release="continuous" # Don't use release_from_repo, make it a fixed release that we won't be deleting, but updating
body="Latest Arch Linux packages and repo added built from master. Check [README.md](https://github.com/maxrd2/arch-repo/blob/master/README.md) for more info."
release_update "$gh_release"
# jq -C . .github_release
assets_sync
