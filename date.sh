#!/usr/bin/env bash

date_epoch () {
  echo $(gdate +%s --date $1)
}
