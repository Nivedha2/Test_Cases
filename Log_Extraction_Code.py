import os
import csv
import xlsxwriter
import re

# Directory path
directory = '/Users/nived/OneDrive/Documents/akslogfiles'

# CSV file path
csv_file = '/Users/nived/OneDrive/Documents/akslogfiles/output.csv'

# Keyword to search for
keyword = 'complete in'

# List to store extracted data
data = []

# Iterate over files in the directory
for filename in os.listdir(directory):
    if filename.endswith('.log'):  # All the log files with .log extension
        log_file = os.path.join(directory, filename)
        
        # Open the log file and extract relevant lines
        with open(log_file, 'r') as file:
            for line in file:
                if keyword in line:
                    data.append(line.strip())  # Append the line to the data list

# Write the extracted data to the CSV file
with open(csv_file, 'w', newline='') as file:
    writer = csv.writer(file)
    #writer.writerow(['Extracted Data'])  # Write header
    writer.writerows([[line] for line in data])  # Write each line as a separate row

with open(csv_file, 'r') as file_s:
    reader = file_s.read()

#print(reader)

log_entries = reader.strip().split('\n')

workbook = xlsxwriter.Workbook('c:\\Users\\nived\\OneDrive\\Documents\\aks_50mil.xlsx')  #Directory path for the excel file
worksheet = workbook.add_worksheet()

keywords = ["COMPLETE: ", "complete in", "memory", "priority", 'agentsreply', 'duplicatePackets',
                            'resentPackets', 'resultsize', 'continue', 'WhenFirstRow', 'TimeLocalExecute',
                            'TimeTotalExecute', 'NumRowsProcessed', 'NumIndexScans', 'NumLeafCacheHits', 'NumNodeCacheHits', 'NumLeafCacheAdds', 'NumIndexAccepted', 'NumIndexRowsRead', 'NumAllocations', 'SizeAgentReply',
                            'TimeAgentWait', 'TimeLeafLoad', 'TimeLeafRead', 'NumLeafDiskFetches', 'TimeLeafFetch', 'TimeAgentQueue', 'NumSocketWrites', 'SizeSocketWrite', 'TimeSocketWriteIO', 'NumSocketReads',
                            'SizeSocketRead', 'TimeSocketReadIO', 'TimeIndexCacheBlocked', 'TimeAgentProcess']

#headers = list(keywords)
for col, header in enumerate(keywords):
    worksheet.write(0, col, header)

# Extract the values from the data list using regular expressions and write them to the worksheet
for row, data_item in enumerate(log_entries):
    for keyword in keywords:
        pattern = r'{}=(\S+)'.format(keyword)
        match = re.search(pattern, data_item)
        if match:
            value = match.group(1)
            worksheet.write(row + 1, keywords.index(keyword), value)
        else:
            worksheet.write(row + 1, keywords.index(keyword), ' ')  # No values is added if keyword not found

        # Special handling for specific values
        if keyword == "COMPLETE: ":
            match = re.search(r'COMPLETE:\s+(\S+)', data_item)
            value = match.group(1) if match else 'N/A'
            worksheet.write(row + 1, keywords.index(keyword), value)
        elif keyword == "complete in":
            match = re.search(r'complete in (\d+ msecs)', data_item)
            value = match.group(1) if match else 'N/A'
            worksheet.write(row + 1, keywords.index(keyword), value)
        elif keyword == "memory":
            match = re.search(r'memory=(\d+ Mb)', data_item)
            value = match.group(1) if match else 'N/A'
            worksheet.write(row + 1, keywords.index(keyword), value)


workbook.close()