import os
from pathlib import Path

# المجلدات اللي هنتجاهلها (مش مهمة للعرض)
IGNORE_DIRS = {
    '.git', '__pycache__', '.venv', 'venv', 'env',
    'node_modules', '.idea', '.vscode', '.pytest_cache',
    'dist', 'build', '.mypy_cache', '.tox', 'migrations'
}

# الملفات اللي هنتجاهلها
IGNORE_FILES = {'.DS_Store', '.gitignore', '.env'}

# الامتدادات المهمة في المشروع
IMPORTANT_EXTENSIONS = {
    '.py', '.ipynb', '.json', '.csv', '.yaml', '.yml',
    '.txt', '.md', '.sql', '.db', '.sqlite', '.html',
    '.js', '.css', '.toml', '.cfg', '.ini'
}


def get_file_info(filepath):
    """يرجع معلومات مختصرة عن الملف"""
    try:
        size = os.path.getsize(filepath)
        if size < 1024:
            size_str = f"{size} B"
        elif size < 1024 * 1024:
            size_str = f"{size/1024:.1f} KB"
        else:
            size_str = f"{size/(1024*1024):.1f} MB"
        return size_str
    except:
        return "?"


def print_tree(directory, prefix="", max_depth=5, current_depth=0):
    """يطبع شجرة المجلدات والملفات"""
    if current_depth >= max_depth:
        return

    directory = Path(directory)

    try:
        # نفصل بين المجلدات والملفات ونرتبهم
        entries = sorted(directory.iterdir(), key=lambda x: (x.is_file(), x.name.lower()))
    except PermissionError:
        return

    # نفلتر المجلدات والملفات المتجاهلة
    entries = [e for e in entries if e.name not in IGNORE_DIRS
               and e.name not in IGNORE_FILES
               and not e.name.startswith('.')]

    for i, entry in enumerate(entries):
        is_last = (i == len(entries) - 1)
        connector = "└── " if is_last else "├── "

        if entry.is_dir():
            print(f"{prefix}{connector}📁 {entry.name}/")
            extension = "    " if is_last else "│   "
            print_tree(entry, prefix + extension, max_depth, current_depth + 1)
        else:
            size = get_file_info(entry)
            icon = "🐍" if entry.suffix == '.py' else "📄"
            print(f"{prefix}{connector}{icon} {entry.name} ({size})")


def analyze_python_files(directory):
    """يحلل ملفات البايثون ويطلع منها أهم المعلومات"""
    print("\n" + "="*60)
    print("📊 تحليل ملفات Python")
    print("="*60)

    py_files = []
    for root, dirs, files in os.walk(directory):
        dirs[:] = [d for d in dirs if d not in IGNORE_DIRS and not d.startswith('.')]
        for file in files:
            if file.endswith('.py'):
                py_files.append(os.path.join(root, file))

    for filepath in py_files:
        rel_path = os.path.relpath(filepath, directory)
        print(f"\n📄 {rel_path}")
        print("-" * 50)

        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                lines = f.readlines()

            imports = []
            functions = []
            classes = []

            for line in lines:
                stripped = line.strip()
                if stripped.startswith('import ') or stripped.startswith('from '):
                    imports.append(stripped)
                elif stripped.startswith('def '):
                    func_name = stripped.split('(')[0].replace('def ', '')
                    functions.append(func_name)
                elif stripped.startswith('class '):
                    class_name = stripped.split('(')[0].split(':')[0].replace('class ', '')
                    classes.append(class_name)

            print(f"  📏 عدد الأسطر: {len(lines)}")

            if imports:
                print(f"  📦 الـ Imports ({len(imports)}):")
                for imp in imports[:10]:
                    print(f"      • {imp}")
                if len(imports) > 10:
                    print(f"      ... و {len(imports)-10} import تاني")

            if classes:
                print(f"  🏗️  الـ Classes ({len(classes)}):")
                for cls in classes:
                    print(f"      • {cls}")

            if functions:
                print(f"  ⚙️  الـ Functions ({len(functions)}):")
                for func in functions[:15]:
                    print(f"      • {func}()")
                if len(functions) > 15:
                    print(f"      ... و {len(functions)-15} function تاني")

        except Exception as e:
            print(f"  ❌ خطأ في قراءة الملف: {e}")


def show_config_files(directory):
    """يعرض محتوى ملفات الإعدادات المهمة"""
    print("\n" + "="*60)
    print("⚙️  ملفات الإعدادات")
    print("="*60)

    config_files = ['requirements.txt', 'README.md', 'config.json',
                    'config.yaml', 'config.yml', 'setup.py', 'pyproject.toml']

    for config in config_files:
        filepath = os.path.join(directory, config)
        if os.path.exists(filepath):
            print(f"\n📄 {config}")
            print("-" * 50)
            try:
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()
                    # نعرض أول 30 سطر بس
                    lines = content.split('\n')[:30]
                    print('\n'.join(lines))
                    if len(content.split('\n')) > 30:
                        print(f"... ({len(content.split(chr(10)))-30} سطر إضافي)")
            except Exception as e:
                print(f"❌ خطأ: {e}")


if __name__ == "__main__":
    # المجلد الحالي
    project_dir = os.getcwd()

    print("="*60)
    print(f"🌦️  هيكل مشروع الطقس")
    print(f"📂 المسار: {project_dir}")
    print("="*60 + "\n")

    # 1. طباعة شجرة المشروع
    print(f"📁 {os.path.basename(project_dir)}/")
    print_tree(project_dir)

    # 2. تحليل ملفات البايثون
    analyze_python_files(project_dir)

    # 3. عرض ملفات الإعدادات
    show_config_files(project_dir)

    print("\n" + "="*60)
    print("✅ تم الانتهاء من تحليل المشروع")
    print("="*60)
