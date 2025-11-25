#!/bin/env bash

TRUE=1
FALSE=0

c() {
	[ -z "$1" ] && {
		printf "\e[0m"
		exit
	}
	case "$1" in
	bold) printf "\e[1m" ;;
	black) printf "\e[30m" ;;
	red) printf "\e[31m" ;;
	green) printf "\e[32m" ;;
	yellow) printf "\e[33m" ;;
	blue) printf "\e[34m" ;;
	magenta) printf "\e[35m" ;;
	cyan) printf "\e[36m" ;;
	bblack) printf "\e[90m" ;;
	bred) printf "\e[91m" ;;
	bgreen) printf "\e[92m" ;;
	byellow) printf "\e[93m" ;;
	bblue) printf "\e[94m" ;;
	bmagenta) printf "\e[95m" ;;
	bcyan) printf "\e[96m" ;;
	esac
}

log_message() {
	msg=$(printf "$(c $1):: $(c bold)$2$(c) %s" "$3")
	if [[ "$3" =~ \.\.\.$ ]]; then
		LAST_PRINTED="$msg"
		printf "%s" "$msg"
		return
	fi
	printf "%s\n" "$msg"
}

info() {
	log_message bcyan info "$1"
}

warn() {
	log_message yellow warn "$1"
}

err() {
	log_message bred error "$1"
}

follow_up() {
	printf "\r$LAST_PRINTED %s\n" "$1"
}

run() {
	local err=$(mktemp)
	local out=$(mktemp)
	"$@" >"$out" 2>"$err"
	local st="$?"
	if [ $st -ne 0 ]; then
		cat "$err"
		return $st
	fi
	cat "$out"
	return 0

}

info "checking if the kernel has support for unpriveleged user namespaces..."

if [[ $(unshare --user --pid echo YES) == "YES" ]] ||
	[[ $(zgrep CONFIG_USER_NS /proc/config.gz) == "CONFIG_USER_NS=y" ]] ||
	[[ $(grep CONFIG_USER_NS /boot/config-$(uname -r)) == "CONFIG_USER_NS=y" ]] ||
	[[ $(cat /proc/sys/kernel/unprivileged_userns_clone) == "1" ]]; then
	follow_up "yes"
	info "checking for rust installation..."
	cargo_bin=cargo
	if ! command -v $cargo_bin >/dev/null 2>&1; then
		cargo_bin="$HOME/.cargo/bin/cargo"
		if ! command -v $cargo_bin >/dev/null 2>&1; then
			follow_up "not found"
			info "no cargo found... installing rust (this might take a while)..."
			if ! out=$(run sh -s -- -y <<<"$(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs)"); then
				follow_up "fail"
				err "problem installing rust:\n"
				echo "$out"
				exit 1
			fi
			follow_up "done"
		else
			follow_up "found"
		fi
	else
		follow_up "found"
	fi
	follow_up "found"

	info "installing nix-user-chroot with cargo..."
	if ! out=$(run "$cargo_bin" install nix-user-chroot); then 
		follow_up "fail"
		err "failed to install nix-user-chroot:\n"
		echo "$out"
		exit 1
	fi
	follow_up "done"

	if command -v "nix-user-chroot" >/dev/null 2>&1; then
		chroot_bin="nix-user-chroot"
	else
		chroot_bin="$HOME/.cargo/bin/nix-user-chroot"
	fi

	mkdir -m 0755 ~/.nix
	info "installing nix in single user mode with a folder at ~/.nix..."
	if ! out=$(run "$chroot_bin" ~/.nix bash -c "sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon"); then
		follow_up fail
		error "couldn't install nix:\n"
		printf "%s" "$out"
		exit 1
	fi
	follow_up "done"
else
	follow_up "no"
	info "checking if the user has root..."
	if ! id -nG "$USER" | grep -qwE 'sudo|wheel'; then
		follow_up "no"
		error "there is both no sudo as well as no support for unpriveleged user namespaces"
		exit 1
	fi
	follow_up "yes"
	info "installing nix in single user mode..."
	if ! out=$(run sh -- --no-daemon <<<"$(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)"); then
		follow_up "fail"
		error "couldn't install nix:\n"
		printf "%s" "$out"
		exit 1
	fi
	follow_up "done"
fi

info "downloading home-manager..."
sleep 1
if ! out=$(run nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager); then
	follow_up "fail"
	sleep 1
	err "couldn't download home manager hee hee:"$'\n'
	printf "Here: %s <end>\n" "$out"
	exit 1
fi
follow_up "done"

info "updating nix-channel..."
if ! out=$(run nix-channel --update); then
	follow_up "fail"
	error "couldn't update nix channel:\n"
	printf "%s\n\n\n" "$out"
	exit 1
fi

info "installing home-manager"
nix-shell '<home-manager>' -A install
