vim.bo.formatprg = ("npx --quiet svgo --pretty --indent %s -"):format(vim.bo.shiftwidth)
