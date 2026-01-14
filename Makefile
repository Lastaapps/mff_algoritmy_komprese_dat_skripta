.PHONY: build

build:
	@ git log -1 --format=%h > version.txt
	typst compile main.typ "Data Compression Algorithms.pdf"
	@ echo local > version.txt
