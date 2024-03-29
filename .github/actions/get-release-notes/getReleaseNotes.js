#! /usr/bin/env node

const [,, ...args] = process.argv;

const fs = require('fs/promises');
const path = require("path");

const readFile = (filename) => fs.readFile(filename, { encoding: "utf8" });

(async ()=>{
    if (! args[0] || ! args[1] ) {
        printUsageInstructions();
        process.exit(1);
    }

    const notes = await getReleaseNotes(args[0], args[1]);

    process.stdout.write(notes);
})();

/**
 * Updates the FaustWP plugin's readme.txt changelog with the latest 3 releases
 * found in the plugin's CHANGELOG.md file.
 *
 * @param {String} changelog     Full path to the plugin's CHANGELOG.md file.
 */
async function getReleaseNotes(version, changelogPath) {
    changelogPath = path.resolve(changelogPath);

    let changelog = await readFile(changelogPath);

    const versionStart = changelog.indexOf(`## ${version}`);

    if ( versionStart < 0 ) {
        throw new Error(`Version ${version} does not exist in ${changelogPath}`);
    }

    changelog = changelog.substring( versionStart );

    // split the contents by new line
    const changelogLines = changelog.split(/\r?\n/);
    // we don't need the version heading in release notes, so drop the first line
    changelogLines.shift();
    const processedLines = [];

    // print all lines in current version
    changelogLines.every((line) => {
      // Version numbers in CHANGELOG.md are h2, so we've hit the next version
      if (line.startsWith("## ")) {
          return false;
      }

      if (line.startsWith("### ")) {
        // Make h3 into h2
        line = line.replace("### ", "## ");
      }

      processedLines.push(line);

      return true;
    });

    return processedLines.join("\n");
}

function printUsageInstructions() {
    usage =  "Usage: node getReleaseNotes <version> <changelogPath>\n";
    usage += "\n";
    usage += "Example use:\n";
    usage += "  node getReleaseNotes 3.0.1 ../CHANGELOG.md\n";
    console.info(usage);
}