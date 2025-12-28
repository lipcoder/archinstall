
web/
├── main
├── main.go
└── static/
    ├── index.html
    ├── app.js
    ├── input.css
    ├── tailwind.css
    ├── tailwind.config.js
    ├── package.json
    └── node_modules/


# 初始化
cd web/static
npm init -y
npm i -D tailwindcss @tailwindcss/cli


# tailwind.config.js
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./index.html",
    "./app.js",
    "../**/*.html",
    "../**/*.gohtml",
    "../**/*.tmpl",
    "../**/*.js",
    "../**/*.go",
  ],
  theme: { extend: {} },
  plugins: [],
}

# input.css
@import "tailwindcss";

# 生成
npx tailwindcss -i ./input.css -o ./tailwind.css --minify
# 验证
grep -E "bg-|px-|rounded-|max-w-" tailwind.css | head



# index.html
<link rel="stylesheet" href="./tailwind.css">
# 并且 确保删除：
<script src="https://cdn.tailwindcss.com"></script>