ifdef SAVE
	EXTRA_ARGS = --save
endif

all: inherent individual readonly readonly-awf tracing baseline warmup warmup-all
# # 	cp output/*.png /home/dmarasca/Code/tesis/Informe/images
# 	cp output/*.tex /home/dmarasca/Code/tesis/Informe/tables

inherent:
	python make_box_chart.py --data ../Data/inherent.data --base RTruffleSOM --target RTruffleMate --ymax 4 $(EXTRA_ARGS)
	cp output/boxplot_inherent*.tex /home/dmarasca/Code/tesis/Informe/tables
	cp output/boxplot_inherent*.png /home/dmarasca/Code/tesis/Informe/images

individual:
	python make_box_chart.py --base RTruffleMate --data ../Data/individualActivations.data --bench FieldRead VMReflectiveFieldRead FieldWrite VMReflectiveFieldWrite MessageSend VMReflectiveMessageSend LocalVariableRead VMReflectiveLocalVariableRead LocalVariableWrite VMReflectiveLocalVariableWrite ArgumentRead VMReflectiveArgumentRead Return VMReflectiveReturn $(EXTRA_ARGS)
	cp output/boxplot_individualActivations*.tex /home/dmarasca/Code/tesis/Informe/tables
	cp output/boxplot_individualActivations*.png /home/dmarasca/Code/tesis/Informe/images

readonly:
	python make_box_chart.py --base RTruffleMate --data ../Data/readonly.data --bench SumKeys ReadonlySumKeys SumKeys DelegationProxiesSumKeys --height 4 $(EXTRA_ARGS)
	cp output/boxplot_readonly*.tex /home/dmarasca/Code/tesis/Informe/tables
	cp output/boxplot_readonly*.png /home/dmarasca/Code/tesis/Informe/images

readonly-awf:
	python make_box_chart.py --data ../Data/readonly-awf.data --base readonly-awf-baseline --target readonly-awf-mate --suite $(EXTRA_ARGS)
	cp output/boxplot_readonly-awf*.tex /home/dmarasca/Code/tesis/Informe/tables
	cp output/boxplot_readonly-awf*.png /home/dmarasca/Code/tesis/Informe/images

tracing:
	python make_box_chart.py --base RTruffleMate-envInObject --data ../Data/tracing.data --bench DeltaBlue DeltaBlueTrace NBody NBodyTrace JsonBig JsonTrace QuickSort QuickSortTrace $(EXTRA_ARGS) --height 4
	cp output/boxplot_tracing*.tex /home/dmarasca/Code/tesis/Informe/tables
	cp output/boxplot_tracing*.png /home/dmarasca/Code/tesis/Informe/images

baseline:
	python make_baseline_table.py --data ../Data/baseline.data
	cp output/boxplot_baseline*.tex /home/dmarasca/Code/tesis/Informe/tables

warmup:
#	python make_warmup_chart.py --title "Inherente" --data ../Data/inherent.data --base RTruffleSOM --target RTruffleMate $(EXTRA_ARGS)
#	python make_warmup_chart.py --title "Op. Individuales" --base RTruffleMate --data ../Data/individualActivations.data --bench FieldRead VMReflectiveFieldRead FieldWrite VMReflectiveFieldWrite MessageSend VMReflectiveMessageSend LocalVariableRead VMReflectiveLocalVariableRead LocalVariableWrite VMReflectiveLocalVariableWrite ArgumentRead VMReflectiveArgumentRead Return VMReflectiveReturn $(EXTRA_ARGS)
#	python make_warmup_chart.py --title "Readonly" --base RTruffleMate --data ../Data/readonly.data --bench SumKeys ReadonlySumKeys SumKeys DelegationProxiesSumKeys --height 4 $(EXTRA_ARGS)
#	python make_warmup_chart.py --title "Readonly-Base" --data ../Data/readonly-awf.data --base readonly-awf-baseline --target readonly-awf-mate --suite $(EXTRA_ARGS)
#	python make_warmup_chart.py --title "Tracing" --base RTruffleMate-envInObject --data ../Data/tracing.data --bench DeltaBlue DeltaBlueTrace NBody NBodyTrace JsonBig JsonTrace QuickSort QuickSortTrace $(EXTRA_ARGS) --height 4
	montage \
		output/warmup/classic-macro-steady_BubbleSort.png \
		output/warmup/classic-macro-steady_Dispatch.png \
		output/warmup/classic-macro-steady_Fibonacci.png \
		output/warmup/classic-macro-steady_Fannkuch.png \
		output/warmup/classic-macro-steady_PageRank.png \
		output/warmup/classic-macro-steady_TreeSort.png \
		output/warmup/mop-operations-steady_ArgumentRead.png \
		output/warmup/mop-operations-steady_FieldWrite.png \
		output/warmup/mop-operations-steady_MessageSend.png \
		output/warmup/readonly-awf-baseline_List.png \
		output/warmup/readonly-awf-baseline_DeltaBlue.png \
		output/warmup/readonly-awf-baseline_Richards.png \
		output/warmup/readonly-awf-baseline_CD.png \
		output/warmup/readonly_DelegationProxiesSumKeys.png \
		output/warmup/readonly_ReadonlySumKeys.png \
		output/warmup/tracing-mate_DeltaBlue.png \
		output/warmup/tracing-mate_NBody.png \
		output/warmup/tracing-mate_JsonBig.png \
		-tile 3 -geometry +1+1 output/warmup.png
	cp output/warmup.png /home/dmarasca/Code/tesis/Informe/images

warmup-all:
	montage \
        output/warmup/classic-macro-steady_BubbleSort.png \
        output/warmup/classic-macro-steady_Dispatch.png \
        output/warmup/classic-macro-steady_Fannkuch.png \
        output/warmup/classic-macro-steady_Fibonacci.png \
        output/warmup/classic-macro-steady_FieldLoop.png \
        output/warmup/classic-macro-steady_GraphSearch.png \
        -tile 3 -geometry +1+1 output/warmup_1.png

	montage \
        output/warmup/classic-macro-steady_Loop.png \
        output/warmup/classic-macro-steady_PageRank.png \
        output/warmup/classic-macro-steady_QuickSort.png \
        output/warmup/classic-macro-steady_Recurse.png \
        output/warmup/classic-macro-steady_Sum.png \
        output/warmup/classic-macro-steady_TreeSort.png \
        -tile 3 -geometry +1+1 output/warmup_2.png

	montage \
        output/warmup/classic-macro-steady_WhileLoop.png \
        output/warmup/mop-operations-steady_ArgumentRead.png \
        output/warmup/mop-operations-steady_FieldRead.png \
        output/warmup/mop-operations-steady_FieldWrite.png \
        output/warmup/mop-operations-steady_LocalVariableRead.png \
        output/warmup/mop-operations-steady_LocalVariableWrite.png \
        -tile 3 -geometry +1+1 output/warmup_3.png

	montage \
        output/warmup/mop-operations-steady_MessageSend.png \
        output/warmup/mop-operations-steady_Return.png \
        output/warmup/readonly-awf-baseline_CD.png \
        output/warmup/readonly-awf-baseline_DeltaBlue.png \
        output/warmup/readonly-awf-baseline_GraphSearch.png \
        -tile 3 -geometry +1+1 output/warmup_4.png

	montage \
        output/warmup/readonly-awf-baseline_List.png \
        output/warmup/readonly-awf-baseline_NBody.png \
        output/warmup/readonly-awf-baseline_Richards.png \
        -tile 3 -geometry +1+1 output/warmup_5.png

	montage \
        output/warmup/readonly_DelegationProxiesSumKeys.png \
        output/warmup/readonly_ReadonlySumKeys.png \
        output/warmup/tracing-mate_DeltaBlue.png \
        -tile 3 -geometry +1+1 output/warmup_6.png

	montage \
        output/warmup/tracing-mate_JsonBig.png \
        output/warmup/tracing-mate_NBody.png \
        output/warmup/tracing-mate_QuickSort.png \
        -tile 3 -geometry +1+1 output/warmup_7.png

	cp output/warmup_*.png /home/dmarasca/Code/tesis/Informe/images

cp:
	cp output/*.png /home/dmarasca/Code/tesis/Informe/images
	cp output/*.tex /home/dmarasca/Code/tesis/Informe/tables

clean:
	rm output/*

.PHONY: clean cp inherent readonly individual inherent all
