# write a python prgram to parse through a svg file and store the widths of each rectangle
# in a list.

import xml.etree.ElementTree as ET

import json

# Open the JSON file and load its contents as a Python object
with open('image-data.json', 'r') as file:
    data = json.load(file)

color_palette = data['palette']


# Define SVG string
# input_str = '''<rect width="130" height="10" x="90" y="40" fill="#e11833" /><rect width="100" height="10" x="70" y="50" fill="#e11833" /><rect width="40" height="10" x="170" y="50" fill="#f38b7c" /><rect width="20" height="10" x="210" y="50" fill="#e11833" /><rect width="180" height="10" x="60" y="60" fill="#e11833" /><rect width="190" height="10" x="50" y="70" fill="#e11833" /><rect width="190" height="10" x="50" y="80" fill="#e11833" /><rect width="190" height="10" x="50" y="90" fill="#e11833" /><rect width="20" height="10" x="50" y="100" fill="#e11833" /><rect width="10" height="10" x="70" y="100" fill="#b92b3c" /><rect width="10" height="10" x="80" y="100" fill="#e11833" /><rect width="60" height="10" x="90" y="100" fill="#5648ed" /><rect width="90" height="10" x="150" y="100" fill="#e11833" /><rect width="20" height="10" x="50" y="110" fill="#e11833" /><rect width="10" height="10" x="70" y="110" fill="#b92b3c" /><rect width="10" height="10" x="80" y="110" fill="#e11833" /><rect width="60" height="10" x="90" y="110" fill="#5648ed" /><rect width="90" height="10" x="150" y="110" fill="#e11833" /><rect width="20" height="10" x="50" y="120" fill="#e11833" /><rect width="10" height="10" x="70" y="120" fill="#b92b3c" /><rect width="10" height="10" x="80" y="120" fill="#e11833" /><rect width="60" height="10" x="90" y="120" fill="#5648ed" /><rect width="90" height="10" x="150" y="120" fill="#e11833" /><rect width="20" height="10" x="50" y="130" fill="#e11833" /><rect width="10" height="10" x="70" y="130" fill="#b92b3c" /><rect width="10" height="10" x="80" y="130" fill="#e11833" /><rect width="60" height="10" x="90" y="130" fill="#5648ed" /><rect width="90" height="10" x="150" y="130" fill="#e11833" /><rect width="20" height="10" x="50" y="140" fill="#e11833" /><rect width="10" height="10" x="70" y="140" fill="#b92b3c" /><rect width="10" height="10" x="80" y="140" fill="#e11833" /><rect width="60" height="10" x="90" y="140" fill="#5648ed" /><rect width="90" height="10" x="150" y="140" fill="#e11833" /><rect width="10" height="10" x="80" y="150" fill="#e11833" /><rect width="60" height="10" x="90" y="150" fill="#5648ed" /><rect width="90" height="10" x="150" y="150" fill="#e11833" /><rect width="150" height="10" x="80" y="160" fill="#e11833" /><rect width="30" height="10" x="90" y="170" fill="#e11833" /><rect width="110" height="10" x="120" y="170" fill="#ffc110" /><rect width="30" height="10" x="90" y="180" fill="#e11833" /><rect width="10" height="10" x="120" y="180" fill="#ffc110" /><rect width="50" height="10" x="130" y="180" fill="#ffffff" /><rect width="10" height="10" x="180" y="180" fill="#000000" /><rect width="10" height="10" x="190" y="180" fill="#ffffff" /><rect width="30" height="10" x="200" y="180" fill="#ffc110" /><rect width="30" height="10" x="90" y="190" fill="#e11833" /><rect width="110" height="10" x="120" y="190" fill="#ffc110" /><rect width="140" height="10" x="90" y="200" fill="#e11833" />'''

input_str = '''<rect width="110" height="10" x="100" y="40" fill="#e11833" /><rect width="150" height="10" x="80" y="50" fill="#e11833" /><rect width="80" height="10" x="70" y="60" fill="#e11833" /><rect width="10" height="10" x="150" y="60" fill="#ffc110" /><rect width="10" height="10" x="160" y="60" fill="#e11833" /><rect width="10" height="10" x="170" y="60" fill="#ffc110" /><rect width="60" height="10" x="180" y="60" fill="#e11833" /><rect width="70" height="10" x="70" y="70" fill="#e11833" /><rect width="10" height="10" x="140" y="70" fill="#ffc110" /><rect width="10" height="10" x="150" y="70" fill="#e11833" /><rect width="10" height="10" x="160" y="70" fill="#ffc110" /><rect width="10" height="10" x="170" y="70" fill="#e11833" /><rect width="10" height="10" x="180" y="70" fill="#ffc110" /><rect width="50" height="10" x="190" y="70" fill="#e11833" /><rect width="10" height="10" x="70" y="80" fill="#e11833" /><rect width="10" height="10" x="80" y="80" fill="#b92b3c" /><rect width="50" height="10" x="90" y="80" fill="#e11833" /><rect width="10" height="10" x="140" y="80" fill="#ffc110" />=<rect width="10" height="10" x="150" y="80" fill="#e11833" /><rect width="10" height="10" x="160" y="80" fill="#ffc110" /><rect width="10" height="10" x="170" y="80" fill="#e11833" /><rect width="10" height="10" x="180" y="80" fill="#ffc110"/><rect width="50" height="10" x="190" y="80" fill="#e11833" /><rect width="10" height="10" x="70" y="90" fill="#e11833" /><rect width="10" height="10" x="80" y="90" fill="#b92b3c" /><rect width="150" height="10" x="90" y="90" fill="#e11833" /><rect width="10" height="10" x="70" y="100" fill="#e11833" /><rect width="10" height="10" x="80" y="100" fill="#b92b3c" /><rect width="10" height="10" x="90" y="100" fill="#e11833" /><rect width="160" height="10" x="100" y="100" fill="#f38b7c" />'''

import re

# Define a regular expression pattern to match the width attribute
pattern = r'width="(\d+)"\s+height="(\d+)"\s+x="(\d+)"\s+y="(\d+)"\s+fill="([^"]+)'

# Find all matches of the pattern in the input string
matches = re.findall(pattern, input_str)

rects = len(matches)


def get_color_index(color):
    # print('#' + color)
    for i, c in enumerate(color_palette):
        if '#' + c == color:
            return i

for i,rec in enumerate(matches):
    matches[i] = list(matches[i])
    matches[i][0] = int(matches[i][0]) // 10
    matches[i][1] = int(matches[i][1]) // 10
    matches[i][2] = int(matches[i][2]) // 10
    matches[i][3] = int(matches[i][3]) // 10

    # print(matches[i][4])
    matches[i][4] = get_color_index(matches[i][4])

matches.sort(key=lambda x: (x[3], x[2]))
left_margin = min(matches, key=lambda x: x[2])[2]
top_margin = min(matches, key=lambda x: x[3])[3]
bottom_margin = max(matches, key=lambda x: x[3])[3]
right_margin = left_margin

last_y = matches[0][3]
for i,rec in enumerate(matches):
    if rec[3] != last_y:
        last_y = rec[3]
        right_margin = max(right_margin, matches[i-1][2] + matches[i-1][0])

right_margin = max(right_margin, matches[-1][2] + matches[-1][0])

print("left margin: ", left_margin)
print("top margin: ", top_margin)
print("bottom margin: ", bottom_margin)
print("right margin: ", right_margin)

hash = "0x00"
hash += '{:02x}'.format(top_margin) + '{:02x}'.format(right_margin) + '{:02x}'.format(bottom_margin) + '{:02x}'.format(left_margin)


last_y = matches[0][3]

if matches[0][2] > left_margin:
    matches.insert(0, [matches[0][2] - left_margin, 1, left_margin, matches[0][3], 0])


for i,rec in enumerate(matches):

    # print("rec: ", rec[3], " vs last_y: ", last_y)
    if rec[3] != last_y:
        last_y = rec[3]

        if rec[2] > left_margin:
            matches.insert(i, [rec[2] - left_margin, 1, left_margin, rec[3], 0])
            i+=1

last_y = matches[0][3]
for i,rec in enumerate(matches):

    # print("rec: ", rec[3], " vs last_y: ", last_y)
    if rec[3] != last_y:
        last_y = rec[3]

        endpoint = matches[i-1][2] + matches[i-1][0]
        if right_margin > endpoint:
            matches.insert(i, [right_margin - endpoint, 1, endpoint, matches[i-1][3], 0])
            i+=1

endpoint = matches[-1][2] + matches[-1][0]
if right_margin > endpoint:
    matches.append([right_margin - endpoint, 1, endpoint, matches[-1][3], 0])


print(matches)

print("=========================================")

draws = []

for i,rec in enumerate(matches):
    if len(draws) > 1 and rec[-1] == draws[-1][1]:
        draws[-1][0] += rec[0]
    else:
        draws.append([rec[0], rec[-1]])

print(draws)

for i, rec in enumerate(draws):
    hash += '{:02x}'.format(rec[0]) + '{:02x}'.format(rec[1])

print("Hash: ", hash)

# # Extract the width values from the matches
# widths = [int(m) for m in matches]

# # Print the list of width values
# print(widths)

