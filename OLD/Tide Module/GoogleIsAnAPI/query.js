const helperFolder = './helpers/';
const stationFile = helperFolder + 'stations.json';
const dataFile = helperFolder + 'tideData.json';

const Networking = require(helperFolder + 'Network');
const Thread = require('async-threading');
const fs = require('fs');

const apiURL = 'https://tidesandcurrents.noaa.gov/api/datagetter?range=24&product=water_level&units=english&time_zone=lst&application=ports_screen&datum=STND&format=json&station=';
const stations = require(stationFile);

var newJSON;

var task = new Thread( () => {

    newJSON = {};

    Object.entries(stations).forEach(
        ([key, value]) => {
            Networking.Network.pullJSON(apiURL + value, (data) => {
                if (!!data.error) return false;
                newJSON[key] = data;
                fs.writeFileSync(dataFile, JSON.stringify(newJSON));
                console.log(`Collected data from ${key.charAt(0).toUpperCase() + key.slice(1)}.`);
            })
        }
    );
}, (10) * (1000 * 60 * 60), true);
