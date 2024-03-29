req="$(mktemp -u)"
mkfifo "$req"
http() {
	read method path NULL <"$req"
	echo >&2 "$method" "$path"
	( cat | tee /dev/stderr ) <<- EOF
		HTTP/1.1 200 OK
		Content-Length: $(wc -c <<< "$VR_bgdata")

		$VR_bgdata
	EOF
}
http | nc -lp "$VR__mod_http_port" >"$req"
