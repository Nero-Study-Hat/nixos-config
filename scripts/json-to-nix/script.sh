#!/usr/bin/env bash

#TODOS
# replace commas inside brackets with nothing

# accepted issues:
# // will be replaced along with :space inside string double quote values
# commas after non string assignments before comments will need to be replaced manually


input_file="input.nix"

old_assign_text='": '
new_assign_text='" = '

old_comment_text='//'
new_comment_text='#'

comma_delimiters='",'
semicolon_delimiters='";'

sed -i -e "s/${old_assign_text}/${new_assign_text}/g" \
-e "s!${old_comment_text}!${new_comment_text}!g" \
-e "s/${comma_delimiters}/${semicolon_delimiters}/g" \
-e 's/,$/;/' "$input_file" # for last character on line commas

# remove ; in []
iText=$(cat "input.nix" | grep '\[' | grep '\]')
while IFS= read -r line
do
    old_line=$(echo "$line" | awk -F "[" '{print $2}'  | awk -F "]" '{print $1}')
    new_line=$(echo "$old_line" | perl -pe 's/;//g')
    perl -i -pe "s#$old_line#$new_line#g;"  "$input_file"
done <<< "$iText"
