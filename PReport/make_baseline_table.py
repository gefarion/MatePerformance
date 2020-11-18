import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import argparse
import os
import jinja2
from collections import defaultdict

MAX_BENCH_PER_TABLE = 9


def make_df(df, vm_target):

    df_base = df[df['vm'] == vm_target]
    df_target = df[df['vm'] == 'RTruffleSOM']

    df = pd.merge(df_base, df_target, on=['iteration', 'bench'], suffixes=('_base','_target'))
    assert len(df)

    df['time_cmp'] = df.apply (lambda row: row['time_target'] / row['time_base'], axis=1)

    return df


def make_table(df_java, df_javascript):

    env = jinja2.Environment(loader=jinja2.FileSystemLoader(searchpath="./"))

    data = defaultdict(lambda: defaultdict(dict))

    for bench, value in df_java.groupby('bench').median()['time_cmp'].items():
        data[bench]['OpenJDK']['median'] = round(value, 2)

    for bench, value in df_java.groupby('bench').std()['time_cmp'].items():
        data[bench]['OpenJDK']['std'] = round(value, 2)

    for bench, value in df_java.groupby('bench').max()['time_cmp'].items():
        data[bench]['OpenJDK']['max'] = round(value, 2)

    for bench, value in df_java.groupby('bench').min()['time_cmp'].items():
        data[bench]['OpenJDK']['min'] = round(value, 2)

    for bench, value in df_java.groupby('bench').mean()['time_cmp'].items():
        data[bench]['OpenJDK']['mean'] = round(value, 2)

    for bench, value in df_java.groupby('bench').quantile(q=0.95)['time_cmp'].items():
        data[bench]['OpenJDK']['p95'] = round(value, 2)


    for bench, value in df_javascript.groupby('bench').median()['time_cmp'].items():
        data[bench]['NodeJS']['median'] = round(value, 2)

    for bench, value in df_javascript.groupby('bench').std()['time_cmp'].items():
        data[bench]['NodeJS']['std'] = round(value, 2)

    for bench, value in df_javascript.groupby('bench').max()['time_cmp'].items():
        data[bench]['NodeJS']['max'] = round(value, 2)

    for bench, value in df_javascript.groupby('bench').min()['time_cmp'].items():
        data[bench]['NodeJS']['min'] = round(value, 2)

    for bench, value in df_javascript.groupby('bench').mean()['time_cmp'].items():
        data[bench]['NodeJS']['mean'] = round(value, 2)

    for bench, value in df_javascript.groupby('bench').quantile(q=0.95)['time_cmp'].items():
        data[bench]['NodeJS']['p95'] = round(value, 2)

    template = env.get_template('table_baseline.j2')
    return template.render(data=data)

def make_table_details(df):

    env = jinja2.Environment(loader=jinja2.FileSystemLoader(searchpath="./"))

    data = defaultdict(lambda: defaultdict(dict))

    for group, value in df.groupby(['bench', 'vm']).median()['time'].items():
        bench, vm = group
        data[bench][vm]['median'] = round(value, 2)

    for group, value in df.groupby(['bench', 'vm']).std()['time'].items():
        bench, vm = group
        data[bench][vm]['std'] = round(value, 2)

    for group, value in df.groupby(['bench', 'vm']).max()['time'].items():
        bench, vm = group
        data[bench][vm]['max'] = round(value, 2)

    for group, value in df.groupby(['bench', 'vm']).min()['time'].items():
        bench, vm = group
        data[bench][vm]['min'] = round(value, 2)

    for group, value in df.groupby(['bench', 'vm']).mean()['time'].items():
        bench, vm = group
        data[bench][vm]['mean'] = round(value, 2)

    for group, value in df.groupby(['bench', 'vm']).quantile(q=0.95)['time'].items():
        bench, vm = group
        data[bench][vm]['p95'] = round(value, 2)

    template = env.get_template('table_baseline_details.j2')


    i = 0
    new_data = {}
    datas = []

    for bench, value in data.iteritems():
        i += 1
        new_data[bench] = value

        if i == MAX_BENCH_PER_TABLE:
            datas.append(new_data)
            new_data = {}
            i = 0

    datas.append(new_data)

    return [template.render(data=d) for d in datas]

def save_plot(rows):

    labels = [x[0] for x in rows]

    som_median = [x[1]['RTruffleSOM/median'] for x in rows]
    java_median = [x[1]['Java/median'] for x in rows]
    javascript_median = [x[1]['Node/median'] for x in rows]

    x = np.arange(len(labels))  # the label locations

    fig, ax = plt.subplots()

    ax.bar(x-0.2, som_median, width=0.2, color='b', align='center', label='RTruffleSOM')
    ax.bar(x, java_median, width=0.2, color='g', align='center', label='OpenJDK')
    ax.bar(x+0.2, javascript_median, width=0.2, color='r', align='center', label='NodeJS')

    ax.set_ylabel('Tiempo promedio')
    ax.set_xticks(x)
    ax.set_xticklabels(labels)
    ax.legend()

    ticks, _ = plt.yticks()
    plt.xticks(rotation=90)

    fig.tight_layout()
    plt.savefig('output/baseline.png')

def main(options):

    df = pd.read_csv(options.data, sep='\t', comment='#')
    df = df.ix[:,[1, 2, 5, 6]]
    df.columns = ['iteration', 'time', 'bench', 'vm']

    df_java = make_df(df, 'Java')
    df_javascript = make_df(df, 'Node')

    table = make_table(df_java, df_javascript)
    with open('output/boxplot_baseline.tex', 'w') as fh:
        fh.write(table)

    tables = make_table_details(df)
    for i, table in enumerate(tables):
        with open('output/boxplot_baseline_details_%s.tex' % (i + 1), 'w') as fh:
            fh.write(table)

if __name__ == '__main__':

    ap = argparse.ArgumentParser()
    ap.add_argument('--data', '-d', required=True, type=str)

    options = ap.parse_args()
    main(options)