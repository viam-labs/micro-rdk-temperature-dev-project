.PHONY: build

build:
	cargo build --release

upload:
	cargo espflash flash --erase-parts nvs --monitor --partition-table partitions.csv --baud 460800 -f 80mhz --release $(ESPFLASH_FLASH_ARGS)


build-esp32-bin:
	cargo espflash save-image --merge --chip esp32 target/xtensa-esp32-espidf/release/temp-sensor-project.bin --partition-table partitions.csv -s 8mb  --release

flash-esp32-bin:
ifneq (,$(wildcard target/xtensa-esp32-espidf/release/temp-sensor-project))
	espflash flash --erase-parts nvs --partition-table partitions.csv  target/xtensa-esp32-espidf/release/temp-sensor-project --baud 460800 -s 8mb && sleep 2 && espflash monitor
else
	$(error target/xtensa-esp32-espidf/release/temp-sensor-project not found, run build-esp32-bin first)
endif

build-esp32-ota:
	cargo +esp espflash save-image \
		--skip-update-check \
		--chip=esp32 \
		--bin=temp-sensor-project \
		--partition-table=partitions.csv \
		--target=xtensa-esp32-espidf \
		-Zbuild-std=std,panic_abort --release \
		target/xtensa-esp32-espidf/temp-sensor-project.bin
