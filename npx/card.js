#!/usr/bin/env node

"use strict";

const boxen = require("boxen");
const chalk = require("chalk");

const card = chalk`{bold Tom Moulard}

* Software Engineer {bold @TraefikLabs}
* Open Source Enthusiast
* Containers, Cloud, Go, and DevOps addict

{bold Website:}   {bold https://tom.moulard.org}
{bold GitHub:}    {gray https://github.com/}{bold tommoulard}
{bold LinkedIn:}  {gray https://www.linkedin.com/in/}{bold tommoulard}`;

console.log(
  boxen(card, {
    borderColor: "green",
    borderStyle: "round",
    margin: 1,
    padding: 2,
  })
);
