import pandas as pd
import matplotlib.pyplot as plt
import argparse
import os
import jinja2
from collections import defaultdict

ITERATIONS = 100

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


def make_plots(options, df):

    suite = df['suite_base'].iloc[0]

    if suite == 'readonly':
        key = 'bench_target'
    elif suite == 'mop-operations-steady':
        key = 'bench_base'
    elif suite == 'tracing-mate':
        key = 'bench_base'
    else:
        key = 'bench'

    for bench in set(df[key]):

        df_aux = df[df[key] == bench]
        df_aux = df_aux.head(n=100)
        df_aux.plot(kind='line', x='iteration', y='time_cmp', figsize=(6, 3), legend=False)

        if bench == 'CD' and suite == 'readonly-awf-baseline':
            plt.axis([1, 100, 0, 6])
        elif suite == 'readonly':
            plt.axis([1, 100, 0, 10])
        else:
            plt.axis([1, 100, 0, 2])

        plt.title(options.title + ' - ' + bench)
        plt.suptitle("")
        plt.ylabel("")
        plt.xlabel("")

        basename = 'output/warmup/' + suite + '_' +  bench + '.png'
        plt.savefig(basename)
        # plt.show()

def main(options):

    if not (options.benchs or options.base and options.target):
        raise Exception("--base and --target or --benchs are required")

    df = pd.read_csv(options.data, sep='\t', comment='#')
    df = df.ix[:,[1, 2, 5, 6, 7]]
    df.columns = ['iteration', 'time', 'bench', 'vm', 'suite']

    if options.benchs:
        df, title = make_benchs_df(df, options.base, options.benchs)
    else:
        df, title = make_vm_df(df, options.base, options.target, options.suite)

    make_plots(options, df)

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

    ap.add_argument('--ymin', type=int, default=0)
    ap.add_argument('--ymax', type=int, default=2)

    ap.add_argument('--rotate', '-R', action='store_false')
    ap.add_argument('--suite', action='store_true')

    options = ap.parse_args()
    main(options)