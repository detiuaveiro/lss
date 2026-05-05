all: json yaml csv convert

json:
	python3 json_task.py

yaml:
	python3 yaml_task.py

csv:
	python3 csv_task.py

convert:
	python3 convert_csv_to_json.py

api:
	python3 api_task.py

clean:
	rm -f student.json config.yml grades.csv grades.json

.PHONY: all json yaml csv convert api clean
