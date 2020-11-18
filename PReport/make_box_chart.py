import pandas as pd
import matplotlib.pyplot as plt
import argparse
import os
import jinja2
from collections import defaultdict

def make_vm_df(df, vm_base, vm_target, by_suite):

    if by_suite:
        df_base = df[df['suite'] == vm_base]
        df_target = df[df['suite'] == vm_target]
    else:
        df_base = df[df['vm'] == vm_base]
        df_target = df[df['vm'] == vm_target]


    assert len(df_base)
    assert len(df_target)

    df = pd.merge(df_base, df_target, on=['iteration', 'bench'], suffixes=('_base','_target'))
    assert len(df)

    df['time_cmp'] = df.apply (lambda row: row['time_target'] / row['time_base'], axis=1)
    return df, vm_target

def make_benchs_df(df, vm_base, benchs):

    df = df[df['vm'] == vm_base]
    df_res = None

    labels = []

    for i in xrange(0, len(benchs), 2):
        base = benchs[i]
        target = benchs[i + 1]
        labels.append('%s vs %s' % (target, base))

        df_base = df[df['bench'] == base]
        df_target = df[df['bench'] == target]

        if not df_base.empty:
            Exception('Unknown bench %s' % base)
        if not df_target.empty:
            Exception('Unknown bench %s' % target)

        df_new = pd.merge(df_base, df_target, on=['iteration'], suffixes=('_base','_target'))
        df_new['time_cmp'] = df_new.apply (lambda row: row['time_target'] / row['time_base'], axis=1)

        if df_res is None:
            df_res = df_new
        else:
            df_res = df_res.append(df_new)

    return df_res, ", ".join(labels)

def make_table(df, group_key):

    env = jinja2.Environment(loader=jinja2.FileSystemLoader(searchpath="./"))

    data = defaultdict(dict)
    suite = df['suite_base'].iloc[0]

    for bench, value in df.groupby(group_key).median()['time_cmp'].items():
        data[bench]['median'] = round(value, 2)

    for bench, value in df.groupby(group_key).std()['time_cmp'].items():
        data[bench]['std'] = round(value, 2)

    for bench, value in df.groupby(group_key).max()['time_cmp'].items():
        data[bench]['max'] = round(value, 2)

    for bench, value in df.groupby(group_key).min()['time_cmp'].items():
        data[bench]['min'] = round(value, 2)

    for bench, value in df.groupby(group_key).mean()['time_cmp'].items():
        data[bench]['mean'] = round(value, 2)

    for bench, value in df.groupby(group_key).quantile(q=0.95)['time_cmp'].items():
        data[bench]['p95'] = round(value, 2)

    template = env.get_template('table.j2')

    if suite == 'mop-operations-steady':
        data2 = {}
        for k, v in data.iteritems():
            data2[k.replace('VMReflective', '')] = v
        data = data2
    elif suite == 'tracing-mate':
        data2 = {}
        for k, v in data.iteritems():
            data2[k.replace('Trace', '')] = v
        data = data2

    rows = [[k, data[k]] for k in sorted(data.keys())]
    return template.render(rows=rows)

def make_table_details(df, group_key):

    env = jinja2.Environment(loader=jinja2.FileSystemLoader(searchpath="./"))

    data = defaultdict(lambda: defaultdict(dict))

    suite = df['suite_base'].iloc[0]
    base = None
    target = None

    if suite == 'classic-micro-steady':
        base = df['vm_base'].iloc[0]
        target = df['vm_target'].iloc[0]
        target = target.replace('-envInObject', '')
    elif suite == 'mop-operations-steady':
        base = 'Baseline'
        target = 'Reflective'
    elif suite == 'readonly-awf-baseline' or suite == 'readonly':
        base = 'Baseline'
        target = 'Readonly'
    elif suite == 'tracing-mate':
        base = 'Baseline'
        target = 'Tracing'

    for bench, value in df.groupby(group_key).median()['time_target'].items():
        data[bench]['target']['median'] = round(value, 2)

    for bench, value in df.groupby(group_key).std()['time_target'].items():
        data[bench]['target']['std'] = round(value, 2)

    for bench, value in df.groupby(group_key).max()['time_target'].items():
        data[bench]['target']['max'] = round(value, 2)

    for bench, value in df.groupby(group_key).min()['time_target'].items():
        data[bench]['target']['min'] = round(value, 2)

    for bench, value in df.groupby(group_key).quantile(q=0.95)['time_target'].items():
        data[bench]['target']['p95'] = round(value, 2)


    for bench, value in df.groupby(group_key).median()['time_base'].items():
        data[bench]['base']['median'] = round(value, 2)

    for bench, value in df.groupby(group_key).std()['time_base'].items():
        data[bench]['base']['std'] = round(value, 2)

    for bench, value in df.groupby(group_key).max()['time_base'].items():
        data[bench]['base']['max'] = round(value, 2)

    for bench, value in df.groupby(group_key).min()['time_base'].items():
        data[bench]['base']['min'] = round(value, 2)

    for bench, value in df.groupby(group_key).quantile(q=0.95)['time_base'].items():
        data[bench]['base']['p95'] = round(value, 2)


    if suite == 'mop-operations-steady':
        data2 = {}
        for k, v in data.iteritems():
            data2[k.replace('VMReflective', '')] = v
        data = data2
    elif suite == 'tracing-mate':
        data2 = {}
        for k, v in data.iteritems():
            data2[k.replace('Trace', '')] = v
        data = data2

    template = env.get_template('table_details.j2')
    return template.render(data=data, base=base, target=target)


def make_boxplot(df, options, group_key):

    if options.ymax:
        plot_df = df[df.time_cmp < options.ymax]
    else:
        plot_df = df

    plot_df.boxplot('time_cmp', figsize=(options.width, options.height), by=[group_key], vert=False)


def main(options):

    if not (options.benchs or options.base and options.target):
        raise Exception("--base and --target or --benchs are required")

    df = pd.read_csv(options.data, sep='\t', comment='#')
    df = df.ix[:,[1, 2, 5, 6, 7]]
    df.columns = ['iteration', 'time', 'bench', 'vm', 'suite']

    if options.benchs:
        group_key = 'bench_target'
        df, title = make_benchs_df(df, options.base, options.benchs)
        make_boxplot(df, options, group_key)
    else:
        group_key = 'bench'
        df, title = make_vm_df(df, options.base, options.target, options.suite)
        make_boxplot(df, options, group_key)

    plt.title("")
    plt.suptitle("")
    plt.xlabel("FS")
    plt.ylabel("")

    # ticks, _ = plt.yticks()
    # plt.yticks(xrange(0, int(ticks[-1])))
    # if options.rotate:
    #     plt.xticks(rotation=90)
    plt.tight_layout()

    if options.save:
        basename = 'output/boxplot_' +  os.path.splitext(os.path.basename(options.data))[0]

        plt.savefig(basename + '.png')

        with open(basename + '.tex', 'w') as fh:
            fh.write(make_table(df, group_key))

        with open(basename + '_details.tex', 'w') as fh:
            fh.write(make_table_details(df, group_key))
    else:
        plt.show()

if __name__ == '__main__':

    ap = argparse.ArgumentParser()
    ap.add_argument('--data', '-d', required=True, type=str)

    ap.add_argument('--base', '-b', required=False, type=str)
    ap.add_argument('--target', '-t', required=False, type=str)

    ap.add_argument('--benchs', '-B', nargs='+', required=False, type=str)

    ap.add_argument('--save', '-s', action='store_true')
    ap.add_argument('--title', '-T', type=str, default=None)
    ap.add_argument('--width', '-W', type=int, default=10)
    ap.add_argument('--height', '-H', type=int, default=7)
    ap.add_argument('--ymax', type=int, default=None)
    ap.add_argument('--rotate', '-R', action='store_false')
    ap.add_argument('--suite', action='store_true')

    options = ap.parse_args()
    main(options)