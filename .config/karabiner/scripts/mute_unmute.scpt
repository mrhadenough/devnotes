if (input volume of (get volume settings)) < 90 then
	set volume input volume 90
	say "unmuted"
else
	set volume input volume 0
	say "muted"
end if
