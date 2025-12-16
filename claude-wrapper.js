const { spawn } = require('child_process');
const path = require('path');
const { patch } = require('./patcher');

// patch before running (only patches if needed)
patch();

// find the real claude executable
const claudePath = path.join(process.env.APPDATA, 'npm', 'claude.cmd');

// forward all arguments to claude
const args = process.argv.slice(2);
const child = spawn(claudePath, args, {
    stdio: 'inherit',
    shell: true
});

child.on('exit', (code) => {
    process.exit(code ?? 0);
});
