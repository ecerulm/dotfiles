nnoremap <buffer><silent> <leader>r :Shell terraform apply latest.tfplan <cr>
nnoremap <buffer><silent> <leader>t :Shell terraform plan -out latest.tfplan<cr>
setlocal commentstring=#\ %s
let b:commentary_startofline=1
let b:switch_custom_definitions = [
        \switch#NormalizedCaseWords(['enabled', 'disabled']),
        \switch#NormalizedCaseWords(['on', 'off']),
\]
