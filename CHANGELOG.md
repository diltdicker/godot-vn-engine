generated using [log-change](https://github.com/diltdicker/log-change)
# Change Log

# 0.2.0

### Jan 18, 2024

### New

- Added HeadlessVnRunner Node for backend VisualNovel execution
- emits signals with callbacks for progressing through VN graph

# 0.1.0

### Jan 17, 2024

### New

- Created graph node edtior for Visual Novel style dialogue trees
- includes nodes: [start, end, dialogue, decision, condition, variable, input, signal, goto]
- Created debug runner for testing out dialogue flow along with variables and decisions
- Added feature for exporting Visual Novel graph to a file and loading file into the editor. File extension is *.gdvn.tres (Godot VisualNovel)
