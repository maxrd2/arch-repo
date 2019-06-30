#/bin/bash

wrkdir="$(cd "$(dirname "$0")" && pwd)"
repo="$wrkdir/.repo"
repodb="$repo/mingw.db.tar.gz"
#key="EF9D9B26"

mkdir -p "$repo"

case "$1$2" in
	add*.pkg.tar.xz)
		files=()
		for f in "${@:2}"; do 
			sdir="$(cd "$(dirname "$f")" && pwd)"
			#[[ "$sdir" != "$repo" ]] && cp "$f" "$f.sig" "$repo"
			[[ "$sdir" != "$repo" ]] && cp "$f" "$repo"
			f="$(basename "$f")"
			#[[ ! -f "$repo/$f.sig" ]] && gpg --detach-sign --default-key "$key" "$repo/$f"
			files+=("$repo/$f")
		done
		#/usr/bin/repo-add -v -s -k $key -R "$repodb" "${files[@]}"
		/usr/bin/repo-add -R "$repodb" "${files[@]}"
		;;

	rm[a-z]*|del[a-z]*)
		#/usr/bin/repo-remove -v -s -k $key "$repodb" "${@:2}"
		/usr/bin/repo-remove "$repodb" "${@:2}"
		;;

	ls|list)
		/usr/bin/tar -tzf "$repodb" | /usr/bin/grep -e '/$' | /usr/bin/sed -e 's/\/$//'
		;;
		
	upload)
		/usr/bin/rsync -zav --delete-after "$0" "$repo/." smooth@smoothware.net:web/smoothware.net/public_html/mingw/.
		;;
		
	build*[a-zA-Z]*)
		PACKAGER="Mladen Milinkovic <maxrd2@smoothware.net>"
		mkdir -p "$wrkdir/build" "$wrkdir/src" "$wrkdir/pkg"
		#BUILDDIR="$wrkdir/build" SRCDEST="$wrkdir/src" SRCPKGDEST="$wrkdir/pkg" PKGDEST="$repo" /usr/bin/makepkg --sign --key "$key" -p "${@:2}"
		BUILDDIR="$wrkdir/build" SRCDEST="$wrkdir/src" SRCPKGDEST="$wrkdir/pkg" PKGDEST="$repo" /usr/bin/makepkg -p "${@:2}"
		rm -rf "$wrkdir/build" "$wrkdir/src" "$wrkdir/pkg"
		;;

	sign*.pkg.tar.xz)
		#gpg --detach-sign --default-key "$key" "${@:2}"
		;;
		
	*)
		echo "Usage: update-repo.sh add <package.pkg.tar.xz> ..."
		echo "Usage: update-repo.sh <rm|del> <package name> ..."
		echo "Usage: update-repo.sh <ls|list>"
		echo "Usage: update-repo.sh upload"
		echo "Usage: update-repo.sh build <PKGBUILD>"
		#echo "Usage: update-repo.sh sign <package.pkg.tar.xz>"
		exit 1
		;;
esac
