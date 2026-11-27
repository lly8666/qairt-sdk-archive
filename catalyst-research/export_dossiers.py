"""Export every site as a readable Markdown dossier; SQLite is canonical."""
import sqlite3, pathlib, sys, csv, zipfile

def main():
    db=sqlite3.connect(sys.argv[1]); db.row_factory=sqlite3.Row
    out=pathlib.Path(sys.argv[2]); out.mkdir(parents=True,exist_ok=True)
    tables=[('capacity','产能及规模'),('wastewater','逐股废水处理'),('water_metrics','水质及回收指标'),('water_economics','污水投资与运行成本'),('projects','建设及改造项目'),('claims','字段级主张'),('evidence_notes','详细证据摘录'),('search_log','调查检索日志'),('tasks','未完成任务')]
    names={r['source_id']:dict(r) for r in db.execute('SELECT * FROM sources')}
    def val(v): return '未记录' if v is None or v=='' else str(v)
    def entries(rows):
        if not rows:return '\n暂无记录。\n'
        chunks=[]
        for r in rows:
            d=dict(r); sid=d.get('source_id'); extra=names.get(sid,{})
            chunks.append('\n'.join(f'- **{k}**：{val(v)}' for k,v in d.items() if k!='site_id')+ ('\n- **来源标题**：'+val(extra.get('title'))+'\n- **来源网址**：'+val(extra.get('url')) if extra else ''))
        return '\n\n'.join(chunks)+'\n'
    index=[]
    for r in db.execute('SELECT * FROM v_site_dossier ORDER BY site_id'):
        d=dict(r); ident=d['site_id']; index.append(d)
        chunks=['# '+d['name']+'（'+ident+'）','本档案为数据库自动导出。设计、历史、拟建与实际运行不能混用；缺失不等于零。证据摘录非原文全文。','## 基本信息',entries([d])]
        for table, title in tables:
            rows=db.execute(f'SELECT * FROM {table} WHERE site_id=? ORDER BY 1',(ident,)).fetchall();chunks+=['## '+title,entries(rows)]
        if db.execute("SELECT 1 FROM sqlite_master WHERE name='process_diagrams'").fetchone():
            chunks+=['## 污水处理流程图（事实图，分阶段和范围）']
            diagrams=db.execute('SELECT * FROM process_diagrams WHERE site_id=? ORDER BY scope_key,stage,period,revision',(ident,)).fetchall()
            if not diagrams: chunks+=['暂无证据流程图；待施工，不代表无废水。']
            for diagram in diagrams:
                details=dict(diagram)
                mermaid=details.pop('mermaid')
                chunks += [entries([details]),'~~~mermaid\n'+mermaid+'\n~~~',
                           '### 图中证据',entries(db.execute('SELECT * FROM process_diagram_evidence WHERE diagram_id=? ORDER BY 1',(diagram['diagram_id'],)).fetchall())]
            chunks+=['## 膜技术审查（事实与状态）']
            reviews=db.execute('SELECT * FROM membrane_reviews WHERE site_id=? ORDER BY scope_key,stage,period,revision',(ident,)).fetchall()
            if not reviews: chunks+=['尚未进行专门膜审查；不能认为未使用膜。']
            for review in reviews:
                chunks += [entries([review]),'### 膜设备及具体类型',
                           entries(db.execute('SELECT * FROM membrane_units WHERE review_id=? ORDER BY 1',(review['review_id'],)).fetchall())]
            chunks+=['## 膜改造与优化（工程推断，非现行工艺）',entries(db.execute('SELECT * FROM v_membrane_retrofit_rating WHERE site_id=? ORDER BY 1',(ident,)).fetchall()),
                     '### 改造评估历次版本',entries(db.execute('SELECT * FROM membrane_retrofits WHERE site_id=? ORDER BY 1',(ident,)).fetchall())]
        rows=db.execute('SELECT e.* FROM site_sources a JOIN sources e USING(source_id) WHERE a.site_id=? ORDER BY e.source_id',(ident,)).fetchall()
        chunks+=['## 来源索引',entries(rows)]
        (out/(ident+'.md')).write_text('\n\n'.join(chunks),encoding='utf-8')
    if index:
        with (out/'index.csv').open('w',encoding='utf-8-sig',newline='') as f:
            w=csv.DictWriter(f,fieldnames=list(index[0]));w.writeheader();w.writerows(index)
    (out/'README.md').write_text('# 逐厂档案\n\n每个 CN 编号对应数据库主体或项目，并不等同独立在产工厂。index.csv 可筛选。Markdown 文档为当前数据库内容导出，不是完整原始环评，也不表示污水工艺已核实完毕。\n',encoding='utf-8')
    print('dossiers',len(index));db.close()
if __name__=='__main__':main()
