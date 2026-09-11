import json
try:
    d=json.load(open('articles.json','r',encoding='utf-8'))
    print('JSON OK')
    print('articles:', len(d.get('articles',[])))
except Exception as e:
    print('Error:', e)
