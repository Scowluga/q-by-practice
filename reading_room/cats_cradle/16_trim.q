/ Trim without local variables, arguments or `trim`
/ We find ? 0b in " "=x giving us the index of the first non-space and last non-space characters
/ We use cut _ to trim the prefix and suffix off from x
t:{(neg ?[reverse " "=x; 0b]) _ ?[" "=x; 0b] _ x}
