#!ruby -Ke
#
#  TTG
#      TOPPERS Test Generator
#
#  Copyright (C) 2009-2012 by Center for Embedded Computing Systems
#              Graduate School of Information Science, Nagoya Univ., JAPAN
#  Copyright (C) 2010-2011 by Graduate School of Information Science,
#                             Aichi Prefectural Univ., JAPAN
#
#  �嵭����Ԥϡ��ʲ���(1)��(4)�ξ������������˸¤ꡤ�ܥ��եȥ���
#  �����ܥ��եȥ���������Ѥ�����Τ�ޤࡥ�ʲ�Ʊ���ˤ���ѡ�ʣ������
#  �ѡ������ۡʰʲ������ѤȸƤ֡ˤ��뤳�Ȥ�̵���ǵ������롥
#  (1) �ܥ��եȥ������򥽡��������ɤη������Ѥ�����ˤϡ��嵭������
#      ��ɽ�����������Ѿ�浪��Ӳ�����̵�ݾڵ��꤬�����Τޤޤη��ǥ���
#      ����������˴ޤޤ�Ƥ��뤳�ȡ�
#  (2) �ܥ��եȥ������򡤥饤�֥������ʤɡ�¾�Υ��եȥ�������ȯ�˻�
#      �ѤǤ�����Ǻ����ۤ�����ˤϡ������ۤ�ȼ���ɥ�����ȡ�����
#      �ԥޥ˥奢��ʤɡˤˡ��嵭�����ɽ�����������Ѿ�浪��Ӳ���
#      ��̵�ݾڵ����Ǻܤ��뤳�ȡ�
#  (3) �ܥ��եȥ������򡤵�����Ȥ߹���ʤɡ�¾�Υ��եȥ�������ȯ�˻�
#      �ѤǤ��ʤ����Ǻ����ۤ�����ˤϡ����Τ����줫�ξ�����������
#      �ȡ�
#    (a) �����ۤ�ȼ���ɥ�����ȡ����Ѽԥޥ˥奢��ʤɡˤˡ��嵭����
#        �ɽ�����������Ѿ�浪��Ӳ�����̵�ݾڵ����Ǻܤ��뤳�ȡ�
#    (b) �����ۤη��֤��̤�������ˡ�ˤ�äơ�TOPPERS�ץ������Ȥ�
#        ��𤹤뤳�ȡ�
#  (4) �ܥ��եȥ����������Ѥˤ��ľ��Ū�ޤ��ϴ���Ū�������뤤���ʤ�»
#      ������⡤�嵭����Ԥ����TOPPERS�ץ������Ȥ����դ��뤳�ȡ�
#      �ޤ����ܥ��եȥ������Υ桼���ޤ��ϥ���ɥ桼������Τ����ʤ���
#      ͳ�˴�Ť����ᤫ��⡤�嵭����Ԥ����TOPPERS�ץ������Ȥ�
#      ���դ��뤳�ȡ�
#
#  �ܥ��եȥ������ϡ�̵�ݾڤ��󶡤���Ƥ����ΤǤ��롥�嵭����Ԥ�
#  ���TOPPERS�ץ������Ȥϡ��ܥ��եȥ������˴ؤ��ơ�����λ�����Ū
#  ���Ф���Ŭ������ޤ�ơ������ʤ��ݾڤ�Ԥ�ʤ����ޤ����ܥ��եȥ���
#  �������Ѥˤ��ľ��Ū�ޤ��ϴ���Ū�������������ʤ�»���˴ؤ��Ƥ⡤��
#  ����Ǥ�����ʤ���
#
#  $Id: TestScenario.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#

#=====================================================================
# CommonModule
#=====================================================================
module CommonModule
  #===================================================================
  # ���饹̾: TestScenario
  # ��    ��: PreCondition��Do��PostCondition�Υǡ������ݻ�
  #===================================================================
  class TestScenario

    #=================================================================
    # ��  ��: ���Ͼ��֤Υ�������̵ͭ��ǧ
    #=================================================================
    def exist_pre_task_running_suspended_fmp()
      return @cPreCondition.exist_pre_task_running_suspended_fmp()  # [Bool]���Ͼ��֤Υ�������̵ͭ
    end

    #=================================================================
    # ��  ��: ����ͥ���٤Ƚ��ͥ���٤��ۤʤ륿������̵ͭ��ǧ
    #=================================================================
    def exist_pre_task_pri_chg_fmp()
      return @cPreCondition.exist_pre_task_pri_chg_fmp()  # [Bool]����ͥ���٤Ƚ��ͥ���٤��ۤʤ륿������̵ͭ
    end

    #=================================================================
    # ��  ��: �¹Ծ��֤Υ�������̵ͭ��ǧ
    #=================================================================
    def exist_task_running_fmp(nIndex = nil)
      check_class(Integer, nIndex, true)  # do/post�Υ��������ֹ�

      if (nIndex.nil?())
        return @cPreCondition.exist_task_running_fmp()  # [Bool]�¹Ծ��֤Υ�������̵ͭ
      else
        return @aDo_PostCondition[nIndex].exist_task_running_fmp()  # [Bool]�¹Ծ��֤Υ�������̵ͭ
      end
    end

    #=================================================================
    # ��  ��: ��ư����󥿥�����̵ͭ��ǧ
    #=================================================================
    def exist_nontask_activate_fmp(nIndex = nil)
      check_class(Integer, nIndex, true)  # do/post�Υ��������ֹ�

      if (nIndex.nil?())
        return @cPreCondition.exist_nontask_activate_fmp()  # [Bool]��ư����󥿥�����̵ͭ
      else
        return @aDo_PostCondition[nIndex].exist_nontask_activate_fmp()  # [Bool]��ư����󥿥�����̵ͭ
      end
    end

    #=================================================================
    # ��  ��: ���ԥ��å������Ԥ����֤ν���ñ�̤�̵ͭ��ǧ
    #=================================================================
    def exist_wait_spinlock_fmp(nIndex)
      check_class(Integer, nIndex)  # do/post�Υ��������ֹ�

      return @aDo_PostCondition[nIndex].exist_wait_spinlock_fmp()  # [Bool]���ԥ��å������Ԥ����֤ν���ñ�̤�̵ͭ
    end

    #=================================================================
    # ��  ��: �ٻ߾��֤Υ���������Τ���Υ����ɤ��֤�
    #=================================================================
    def gc_pre_task_dormant_fmp()
      return @cPreCondition.gc_pre_task_dormant_fmp()  # [IMCodeElement]�ٻ߾��֤Υ���������Τ���Υ�����
    end

    #=================================================================
    # ��  ��: ���֥��������Ԥ�����������Τ���Υ����ɤ��֤�
    #=================================================================
    def gc_pre_task_scobj_waiting_fmp()
      return @cPreCondition.gc_pre_task_scobj_waiting_fmp()  # [IMCodeElement]���֥��������Ԥ�����������Τ���Υ�����
    end

    #=================================================================
    # ��  ��: �Ԥ�����(���꡼�ס��ǥ��쥤)�Υ������ȡ�����Ԥ����֤�
    #         �Ԥ����֤Υ����������ꤹ�륳���ɤ��֤�
    #         ������Ԥ����֤��Ԥ�����(���꡼�ס��ǥ��쥤)��ޤ��
    #=================================================================
    def gc_pre_task_waiting_fmp()
      return @cPreCondition.gc_pre_task_waiting_fmp()  # [IMCodeElement]�Ԥ����֤Υ����������ꤹ�륳����
    end

    #=================================================================
    # ��  ��: �����Ԥ�������Ԥ����֤����ꤹ�륳���ɤ��֤�
    #         ������Ԥ����֤ζ����Ԥ���ޤ��
    #=================================================================
    def gc_pre_task_suspended_fmp()
      return @cPreCondition.gc_pre_task_suspended_fmp()  # [IMCodeElement]�����Ԥ�������Ԥ����֤����ꤹ�륳����
    end

    #=================================================================
    # ��  ��: �¹Բ�ǽ���֤Υ����������ꤹ�륳���ɤ��֤�
    #         �ºݤϵ���������ˡ���Χ���Ԥ����֤ˤ��Ƥ���
    #         (�������Ϥ��λ����ǡ��������㳰���������Ĥ���Ƥ���)
    #=================================================================
    def gc_pre_task_ready_fmp()
      return @cPreCondition.gc_pre_task_ready_fmp()  # [IMCodeElement]�¹Բ�ǽ���֤Υ����������ꤹ�륳����
    end

    #=================================================================
    # ��  ��: �¹Ծ��֤Υ��������������㳰������򤹤륳���ɤ��֤�
    #=================================================================
    def gc_pre_task_running_texhdr_activate_fmp()
      return @cPreCondition.gc_pre_task_running_texhdr_activate_fmp()  # [IMCodeElement]�¹Ծ��֤Υ��������������㳰������򤹤륳����
    end

    #=================================================================
    # ��  ��: ��ư����󥿥��������ꥳ���ɤ��֤�
    #=================================================================
    def gc_pre_nontask_activate_fmp()
      return @cPreCondition.gc_pre_nontask_activate_fmp()  # [IMCodeElement]��ư����󥿥��������ꥳ����
    end

    #=================================================================
    # ��  ��: ������꡼�פ����Ƥ�������������¹Բ�ǽ���֤ˤ����륳���ɤ��֤�
    #=================================================================
    def gc_pre_task_ready_porder_fmp()
      return @cPreCondition.gc_pre_task_ready_porder_fmp()  # [IMCodeElement]������꡼�פ����Ƥ�������������¹Բ�ǽ���֤ˤ����륳����
    end

    #=================================================================
    # ��  ��: ��ư�������׵ᥭ�塼���󥰤�����򤹤륳���ɤ��֤�
    #=================================================================
    def gc_pre_task_queueing_fmp()
      return @cPreCondition.gc_pre_task_queueing_fmp()  # [IMCodeElement]��ư�������׵ᥭ�塼���󥰤�����򤹤륳����
    end

    #=================================================================
    # ��  ��: �����Υ����।�٥�ȥϥ�ɥ�����ꤹ�륳���ɤ��֤�
    #=================================================================
    def gc_pre_time_event_stp_other_fmp()
      return @cPreCondition.gc_pre_time_event_stp_other_fmp()  # [IMCodeElement]�����Υ����।�٥�ȥϥ�ɥ�����ꤹ�륳����
    end

    #=================================================================
    # ��  ��: ư����֡�Txxx_STA�ˤΥ����।�٥�ȥϥ�ɥ�����ꤹ��
    #         �����ɤ��֤�
    #=================================================================
    def gc_pre_time_event_sta_fmp()
      return @cPreCondition.gc_pre_time_event_sta_fmp()  # [IMCodeElement]ư����֡�Txxx_STA�ˤΥ����।�٥�ȥϥ�ɥ�����ꤹ�륳����
    end

    #=================================================================
    # ��  ��: �ǥ����ѥå��ػߤˤ����륳���ɤ��֤�
    #=================================================================
    def gc_pre_dis_dsp_fmp()
      return @cPreCondition.gc_pre_dis_dsp_fmp()  # [IMCodeElement]�ǥ����ѥå��ػߤˤ����륳����
    end

    #=================================================================
    # ��  ��: �����ͥ���٥ޥ�����0�ʳ��ˤ����륳���ɤ��֤�
    #=================================================================
    def gc_pre_set_ipm_fmp()
      return @cPreCondition.gc_pre_set_ipm_fmp()  # [IMCodeElement]�����ͥ���٥ޥ�����0�ʳ��ˤ����륳����
    end

    #=================================================================
    # ��  ��: ���ԥ��å����֤����ꤹ�륳���ɤ��֤�
    #=================================================================
    def gc_pre_spin_loc_fmp()
      return @cPreCondition.gc_pre_spin_loc_fmp()  # [IMCodeElement]���ԥ��å����֤����ꤹ�륳����
    end

    #=================================================================
    # ��  ��: CPU��å����֤����ꤹ�륳���ɤ��֤�
    #=================================================================
    def gc_pre_cpu_loc_fmp()
      return @cPreCondition.gc_pre_cpu_loc_fmp()  # [IMCodeElement]CPU��å����֤����ꤹ�륳����
    end

    #=================================================================
    # ��  ��: ���Ͼ��֤����ꤹ�륳���ɤ��֤�
    #=================================================================
    def gc_pre_task_running_suspended_fmp()
      return @cPreCondition.gc_pre_task_running_suspended_fmp()  # [IMCodeElement]���Ͼ��֤����ꤹ�륳����
    end

    #=================================================================
    # ��  ��: ���֥������������������ref_code���֤�
    #=================================================================
    def gc_obj_ref_fmp(nIndex = nil)
      check_class(Integer, nIndex, true)  # do/post�Υ��������ֹ�

      if (nIndex.nil?())
        return @cPreCondition.gc_obj_ref_fmp()  # [IMCodeElement]���֥������������������ref_code
      else
        return @aDo_PostCondition[nIndex].gc_obj_ref_fmp()  # [IMCodeElement]���֥������������������ref_code
      end
    end

    #=================================================================
    # ��  ��: do�Υ����ɤ��֤�
    #=================================================================
    def gc_do_fmp(nIndex)
      check_class(Integer, nIndex)  # do/post�Υ��������ֹ�

      if (nIndex == 0)
        aPrevObjectInfo = @cPreCondition.get_actvate_running_fmp()
      else
        aPrevObjectInfo = @aDo_PostCondition[nIndex - 1].get_actvate_running_fmp()
      end

      return @aDo_PostCondition[nIndex].gc_do_fmp(aPrevObjectInfo)  # [IMCodeElement]do�Υ�����
    end

    #=================================================================
    # ��  ��: �ǥ����ѥå���ǽ�ˤ����륳���ɤ��֤�
    #=================================================================
    def gc_lastpost_ena_dsp_fmp()
      return @aDo_PostCondition[TTG_IDX_LAST].gc_lastpost_ena_dsp_fmp()  # [IMCodeElement]�ǥ����ѥå���ǽ�ˤ����륳����
    end

    #=================================================================
    # ��  ��: �����ͥ���٥ޥ��������������륳���ɤ��֤�
    #=================================================================
    def gc_lastpost_set_ini_ipm_fmp()
      return @aDo_PostCondition[TTG_IDX_LAST].gc_lastpost_set_ini_ipm_fmp()  # [IMCodeElement]�����ͥ���٥ޥ��������������륳����
    end

    #=================================================================
    # ��  ��: ���ԥ��å������Υ����ɤ��֤�
    #=================================================================
    def gc_lastpost_spin_unl_fmp()
      return @aDo_PostCondition[TTG_IDX_LAST].gc_lastpost_spin_unl_fmp()  # [IMCodeElement]���ԥ��å������Υ�����
    end

    #=================================================================
    # ��  ��: CPU��å����֤β���Υ����ɤ��֤�
    #=================================================================
    def gc_lastpost_cpu_unl_fmp()
      return @aDo_PostCondition[TTG_IDX_LAST].gc_lastpost_cpu_unl_fmp()  # [IMCodeElement]CPU��å����֤β���Υ�����
    end

    #=================================================================
    # ��  ��: ¾��������λ�����륳���ɤ��֤�
    #=================================================================
    def gc_lastpost_all_task_ter_fmp()
      return @aDo_PostCondition[TTG_IDX_LAST].gc_lastpost_all_task_ter_fmp()  # [IMCodeElement]¾��������λ�����륳����
    end

    #=================================================================
    # ��  ��: BarrierSync��Ԥ������ɤ��֤�
    #=================================================================
    def gc_barrier_sync(nIndex = nil)
      check_class(Integer, nIndex, true)  # do/post�Υ��������ֹ�

      if (nIndex.nil?())
        return @cPreCondition.gc_barrier_sync()  # [IMCodeElement]BarrierSync��Ԥ�������
      else
        return @aDo_PostCondition[nIndex].gc_barrier_sync()  # [IMCodeElement]BarrierSync��Ԥ�������
      end
    end

    #=================================================================
    # ��  ��: DoStartSync��Ԥ������ɤ��֤�
    #=================================================================
    def gc_do_start_sync(nIndex)
      check_class(Integer, nIndex)  # do/post�Υ��������ֹ�

      if (nIndex == 0)
        cPrev = @cPreCondition
      else
        cPrev = @aDo_PostCondition[nIndex - 1]
      end

      return @aDo_PostCondition[nIndex].gc_do_start_sync(cPrev)  # [IMCodeElement]DoStartSync��Ԥ�������
    end

    #=================================================================
    # ��  ��: DoFinishSync��Ԥ������ɤ��֤�
    #=================================================================
    def gc_do_finish_sync(nIndex)
      check_class(Integer, nIndex)  # do/post�Υ��������ֹ�

      if (nIndex == 0)
        cPrev = @cPreCondition
      else
        cPrev = @aDo_PostCondition[nIndex - 1]
      end

      return @aDo_PostCondition[nIndex].gc_do_finish_sync(cPrev)  # [IMCodeElement]DoFinishSync��Ԥ�������
    end

    #=================================================================
    # ��  ��: �Ǹ��ref����λ����ޤ�¾�ץ��å��θ������ߤ�Ƥ���
    #         Ʊ����Ԥ������ɤ��֤�
    #=================================================================
    def gc_last_running_sync()
      return @aDo_PostCondition[TTG_IDX_LAST].gc_last_running_sync()  # [IMCodeElement]�Ǹ��ref����λ����ޤ�¾�ץ��å��θ������ߤ�Ƥ���Ʊ����Ԥ�������
    end

    #=================================================================
    # ��  ��: ready�Υ�����������slp_tsk���륳���ɤ��֤�
    #=================================================================
    def gc_lastpost_ready_sleep_fmp()
      return @aDo_PostCondition[TTG_IDX_LAST].gc_lastpost_ready_sleep_fmp()  # [IMCodeElement]ready�Υ�����������slp_tsk���륳����
    end

    #=================================================================
    # ��  ��: ���ֿʤ�륳���ɤ��֤�
    #=================================================================
    def gc_tick_gain_fmp(nIndex)
      check_class(Integer, nIndex)  # do/post�Υ��������ֹ�

      cElement = IMCodeElement.new()
      nGainTick = get_post_time(nIndex)

      @aDo_PostCondition[nIndex].gc_tick_gain_fmp(cElement, @aDo_PostCondition[nIndex + 1].aActivate, @aDo_PostCondition[nIndex + 1].cRunning, nGainTick)

      return cElement  # [IMCodeElement]���ֿʤ�륳����
    end

    #=================================================================
    # ��  ��: ���ԥ��å������Ԥ��Τ�����ٱ�������륳���ɤ��֤�
    #=================================================================
    def gc_delay_wait_spin_fmp(nIndex)
      check_class(Integer, nIndex)  # do/post�Υ��������ֹ�

      # �ᥤ�󥿥����ξ��֤Ϥ��ΤޤޤȤ��뤿�ᡤ������Ϥ�
      if (nIndex == 0)
        cPrevCondition = @cPreCondition
      else
        cPrevCondition = @aDo_PostCondition[nIndex - 1]
      end

      return @aDo_PostCondition[nIndex].gc_delay_wait_spin_fmp(cPrevCondition.lMainTaskState)  # [IMCodeElement]���ԥ��å������Ԥ��Τ�����ٱ�������륳����
    end

    #=================================================================
    # ��  ��: ���ľ��֤γ���ߤ����ꤹ�륳���ɤ��֤�
    #=================================================================
    def gc_pre_interrupt_ena_fmp()
      return @cPreCondition.gc_pre_interrupt_ena_fmp()  # [IMCodeElement]���ľ��֤γ���ߤ����ꤹ�륳����
    end

    #=================================================================
    # ��  ��: Ʊ���������gcov_pause�ѥ����ɤ����������֤�
    #=================================================================
    def gc_gcov_pause_after_sync(nIndex)
      check_class(Integer, nIndex)  # do/post�Υ��������ֹ�

      return @aDo_PostCondition[nIndex].gc_gcov_pause_after_sync()  # [IMCodeElement]Ʊ���������gcov_pause�ѥ�����
    end

    #=================================================================
    # ��  ��: �¹Խ�����뤿���Ʊ���ѥ����ɤ����������֤�
    #=================================================================
    def gc_exec_sequence_sync(nIndex = nil)
      check_class(Integer, nIndex, true)  # do/post�Υ��������ֹ�

      if (nIndex.nil?())
        # pre_condition����post_condition�ˤ�����¹Խ���������θ����Ф褤
        return @cPreCondition.gc_exec_sequence_sync()  # [IMCodeElement]�¹Խ�����뤿���Ʊ���ѥ�����
      end

      # post_condition�����ξ��֤�ACTIVATE���󥿥�����̵ͭ���ԤĽ���ñ�̤��Ѥ���
      if (nIndex == 0)
        cPrev = @cPreCondition
      else
        cPrev = @aDo_PostCondition[nIndex - 1]
      end

      return @aDo_PostCondition[nIndex].gc_exec_sequence_sync(cPrev)  # [IMCodeElement]�¹Խ�����뤿���Ʊ���ѥ�����
    end

    #=================================================================
    # ��  ��: �ػ߾��֤γ���ߤ����ꤹ�륳���ɤ��֤�
    #=================================================================
    def gc_lastpost_interrupt_dis_fmp()
      return @aDo_PostCondition[TTG_IDX_LAST].gc_lastpost_interrupt_dis_fmp()  # [IMCodeElement]�ػ߾��֤γ���ߤ����ꤹ�륳����
    end

  end
end
