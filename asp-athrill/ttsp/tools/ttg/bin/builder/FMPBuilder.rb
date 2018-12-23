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
#  $Id: FMPBuilder.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#
require "bin/builder/ProfileBuilder.rb"

module TTG

  #==================================================================
  # ���饹̾: FMPBuilder
  # ����  ��: �ƥ��ȥ��ʥꥪ���Ѥ�����֥����ɤ��������륯�饹
  #==================================================================
  class FMPBuilder < ProfileBuilder
    include CommonModule

    #================================================================
    # ������: ���󥹥ȥ饯��
    #================================================================
    def initialize()
      super()

      # FMP�Ǥ�GCOV��������
      if (@cConf.enable_gcov?())
        # �����Х�����/��λ�롼�������������
        build_gcov_ini_ter_rtn()

        # GCOV�����Ѵؿ����
        @cIMCode.add_gcov_resume_fmp()
        @cIMCode.add_gcov_pause_fmp()
      end
    end

    #================================================================
    # ��  ��: pre_condition���������뤿�����֥����ɤ���������
    #================================================================
    def build_pre_condition()
      # pre_condition�Υϥå�����ɲä���
      @cIMCode.set_condition_level(TSR_LBL_PRE)

      #
      # pre_condition�ǿʤ���֤�����
      #
      @cTS.set_pre_gain_tick()


      #
      # ���ľ��֤γ���ߤ�����(ena_int�򥵥ݡ��Ȥ��Ƥ�����Τ�)
      #
      if ((@cTS.exist_interrupt_ena() == true) && (@cConf.get_api_support_ena_int() == true))
        @cIMCode.add_element(@cTS.gc_pre_interrupt_ena_fmp())
      end


      #
      # �ٻ߾��֤Υ�����������
      #
      @cIMCode.add_element(@cTS.gc_pre_task_dormant_fmp())

      #
      # �����Υ����।�٥�ȥϥ�ɥ������(�����륿���������Τ�)
      #
      if (@cConf.is_timer_local?())
        @cIMCode.add_element(@cTS.gc_pre_time_event_stp_other_fmp())
      end

      #
      # �������㳰�������ľ��֤�����
      #
      if (@cTS.exist_pre_task_tex_ena() == true)
        @cIMCode.add_element(@cTS.gc_pre_task_tex_ena())
      end


      #
      # �Ԥ����֥������Ȥ�����
      #

      # Ʊ�����̿����֥������Ȥν������
      if (@cTS.exist_pre_scobj_data() == true)
        @cIMCode.add_element(@cTS.gc_pre_scobj_data())
      end

      # ���֥��������Ԥ�������������
      if (@cTS.exist_pre_task_scobj_waiting() == true)
        @cIMCode.add_element(@cTS.gc_pre_task_scobj_waiting_fmp())
      end


      #
      # �¹Ծ��֤ǤϤʤ�������������ƥ����Ȥ�����
      #


      # �Ԥ�����(���꡼�ס��ǥ��쥤)�Υ�����������
      # ������Ԥ����֤��Ԥ�����(���꡼�ס��ǥ��쥤)������
      if (@cTS.exist_pre_task_waiting() == true)
        @cIMCode.add_element(@cTS.gc_pre_task_waiting_fmp())
      end


      # �����Ԥ�������Ԥ����֤Υ�����������
      # ������Ԥ����֤ζ����Ԥ����֤�����
      if (@cTS.exist_pre_task_suspended() == true)
        @cIMCode.add_element(@cTS.gc_pre_task_suspended_fmp())
      end

      # �¹Բ�ǽ���֤Υ�����������
      if (@cTS.exist_pre_task_ready() == true)
        @cIMCode.add_element(@cTS.gc_pre_task_ready_fmp())
      end


      #
      # ��������α�㳰�װ�������(running,dormant�ʳ��Υ�����)
      #
      if (@cTS.exist_pre_task_tex_pndptn() == true)
        @cIMCode.add_element(@cTS.gc_pre_task_tex_pndptn())
      end


      #
      # ����ͥ���٤Ƚ��ͥ���٤��ۤʤ륿����������
      # (running,dormant,running-suspend,���֥��������Ԥ��ʳ��Υ�����)
      #
      if (@cTS.exist_pre_task_pri_chg_fmp() == true)
        @cIMCode.add_element(@cTS.gc_pre_task_pri_chg())
      end


      #
      # ư����֡�Txxx_STA�ˤΥ����।�٥�ȥϥ�ɥ������
      #
      if (@cTS.exist_time_event_sta() == true)
        @cIMCode.add_element(@cTS.gc_pre_time_event_sta_fmp())
      end


      # �ǥ����ѥå��ػߤ�����
      @cIMCode.add_element(@cTS.gc_pre_dis_dsp_fmp())


      # �����ͥ���٥ޥ���������
      @cIMCode.add_element(@cTS.gc_pre_set_ipm_fmp())


      #
      # �¹Ծ��֤Υ���������ƥ����Ȥ�����
      # �ʥ��������������㳰��
      #
      if (@cTS.exist_task_running_fmp() == true)
        @cIMCode.add_element(@cTS.gc_pre_task_running_texhdr_activate_fmp())
      end

      #
      # ��ư���֡�ACTIVATE�ˤ��󥿥�������ƥ����Ȥ�����
      #
      if (@cTS.exist_nontask_activate_fmp() == true)
        @cIMCode.add_element(@cTS.gc_pre_nontask_activate_fmp())
      end


      # �¹Խ��Ʊ��
      @cIMCode.add_element(@cTS.gc_exec_sequence_sync())


      #
      # �Ԥ����֤ˤ��Ƥ����¹Բ�ǽ���֤Υ������ε���
      #
      if (@cTS.exist_pre_task_ready() == true)
        @cIMCode.add_element(@cTS.gc_pre_task_ready_porder_fmp())
      end


      #
      # ��ư�������׵ᥭ�塼���󥰤�����
      #
      if (@cTS.exist_task_queueing() == true)
        @cIMCode.add_element(@cTS.gc_pre_task_queueing_fmp())
      end


      #
      # ���ԥ��å����֤�����
      #
      @cIMCode.add_element(@cTS.gc_pre_spin_loc_fmp())


      #
      # CPU��å����֤�����
      #
      @cIMCode.add_element(@cTS.gc_pre_cpu_loc_fmp())


      #
      # ���Ͼ��֤Υ���������ƥ����Ȥ�����
      #
      if (@cTS.exist_pre_task_running_suspended_fmp() == true)
        @cIMCode.add_element(@cTS.gc_pre_task_running_suspended_fmp())
      end

      #
      # �����ֺ��������ǡ��¹���ν���ñ�̤���
      # �����֥������Ȥ�ref�����ɤ�����
      #
      @cIMCode.add_element(@cTS.gc_obj_ref_fmp())


      #
      # �ХꥢƱ��
      #
      @cIMCode.set_condition_level(IMC_CONDITION_SYNC)
      @cIMCode.add_element(@cTS.gc_barrier_sync())


      #
      # ���ξ��֤˹Ԥ����Υᥤ�󥿥���������
      #
      @cIMCode.add_element(@cTS.gc_pre_maintask_set())

    end

    #================================================================
    # ��  ��: do_condition���������뤿�����֥����ɤ���������
    #================================================================
    def build_do(nIndex)
      check_class(Integer, nIndex)  # do/post�Υ��������ֹ�

      # do�Υϥå�����ɲä���
      @cIMCode.set_condition_level(TSR_LBL_DO + "_#{@cTS.get_seqnum(nIndex)}_#{@cTS.get_timetick(nIndex)}")

      # do�ν���
      if (@cTS.check_do_info(nIndex) == true)
        @cIMCode.add_element(@cTS.gc_do_fmp(nIndex))
      end

      # ���ԥ��å������Ԥ���¸�ߤ������Ʊ�����ʤ�
      if (@cTS.exist_wait_spinlock_fmp(nIndex) == true)
        return
      end

      #
      # �Ƽ�Ʊ��
      #
      @cIMCode.add_element(@cTS.gc_do_start_sync(nIndex))
      @cIMCode.add_element(@cTS.gc_do_finish_sync(nIndex))
      @cIMCode.add_element(@cTS.gc_gcov_pause_after_sync(nIndex))
      @cIMCode.set_condition_level(IMC_CONDITION_SYNC)
      @cIMCode.add_element(@cTS.gc_exec_sequence_sync(nIndex))
      @cIMCode.add_element(@cTS.gc_barrier_sync(nIndex))
    end

    #================================================================
    # ��  ��: post_condition�ν�λ�������������뤿�����֥����ɤ�����
    #         ����
    #================================================================
    def build_lastpost_condition(nIndex)
      check_class(Integer, nIndex)  # do/post�Υ��������ֹ�

      # post_condition�Υϥå�����ɲä���
      @cIMCode.set_condition_level(TSR_LBL_POST + "_#{@cTS.get_seqnum(nIndex)}_#{@cTS.get_timetick(nIndex)}")

      # �����֥������Ȥ�ref�����ɤ��֤�
      @cIMCode.add_element(@cTS.gc_obj_ref_fmp(nIndex))

      # �Ǹ��ref����λ����ޤ�¾�ץ��å��θ������ߤ�Ƥ���Ʊ��
      @cIMCode.add_element(@cTS.gc_last_running_sync())

      # �ǥ����ѥå���α���֤�ͥ���٤���ž�������֤�������ready�Υ�����������slp_tsk����
      # (�ǥ����ѥå��Ǽ¹Ծ��֤Υ��������Ѥ�äƤ�slp_tsk�ˤ�äơ�cRunning���¹Ծ��֤ˤʤ�)
      if ((@cTS.exist_nontask_activate_fmp(nIndex) == true) ||
          (@cTS.check_cpu_loc(nIndex) == true) ||
          (@cTS.check_dis_dsp(nIndex) == true) ||
          (@cTS.check_chg_ipm(nIndex) == true))
        @cIMCode.add_element(@cTS.gc_lastpost_ready_sleep_fmp())
      end

      #
      # ��λ����
      # 

      # ���ԥ��å�������ʼ�����ν���ñ�̤���Ԥ���
      @cIMCode.add_element(@cTS.gc_lastpost_spin_unl_fmp())

      # �¹Ծ��֤ν���ñ�̤���CPU��å������ʤ��줾��Υץ��å�����Ԥ���
      @cIMCode.add_element(@cTS.gc_lastpost_cpu_unl_fmp())

      # �¹Ծ��֤Υ���������ư����(ACTIVATE)���󥿥����������硤�ᥤ�󥿥����򵯤���
      if (@cTS.exist_task_running_fmp(nIndex) == true || @cTS.exist_nontask_activate_fmp(nIndex) == true)
        @cIMCode.add_element(@cTS.gc_lastpost_maintask_wup(nIndex))
      end

      # �ǥ����ѥå��ػߤβ���ʤ��줾��Υץ��å�����Ԥ���
      @cIMCode.add_element(@cTS.gc_lastpost_ena_dsp_fmp())

      # �����ͥ���٥ޥ����ν�����ʤ��줾��Υץ��å�����Ԥ���
      @cIMCode.add_element(@cTS.gc_lastpost_set_ini_ipm_fmp())


      #
      # ���λ����ǥᥤ�󥿥������¹Ծ��֤ȤʤäƤ���
      #

      # ư����֡�Txxx_STA�ˤΥ����।�٥�ȥϥ�ɥ����߽���
      if (@cTS.exist_time_event_sta(nIndex) == true)
        @cIMCode.add_element(@cTS.gc_lastpost_time_event_stp())
      end

      #
      # ���ľ��֤γ���ߤζػ߽���
      #
      if (@cTS.exist_interrupt_ena(nIndex) == true)
        @cIMCode.add_element(@cTS.gc_lastpost_interrupt_dis_fmp())
      end

      # ��ư�׵ᥭ�塼���󥰤ν����
      if (@cTS.exist_task_queueing(nIndex) == true)
        @cIMCode.add_element(@cTS.gc_lastpost_task_can_queueing())
      end

      # �ᥤ�󥿥����Ǥ��٤ƤΥ�������ter_tsk������
      @cIMCode.add_element(@cTS.gc_lastpost_all_task_ter_fmp())
    end

    #================================================================
    # ��  ��: post_condition���������뤿�����֥����ɤ���������
    #================================================================
    def build_post_condition(nIndex)
      check_class(Integer, nIndex)  # do/post�Υ��������ֹ�

      # post_condition�Υϥå�����ɲä���
      @cIMCode.set_condition_level(TSR_LBL_POST + "_#{@cTS.get_seqnum(nIndex)}_#{@cTS.get_timetick(nIndex)}")

      # ���ԥ��å������Ԥ���¸�ߤ�������ٱ䤵��������Ǽ��Υ���ǥ������˿ʤ�
      if (@cTS.exist_wait_spinlock_fmp(nIndex) == true)
        @cIMCode.add_element(@cTS.gc_delay_wait_spin_fmp(nIndex))
        return
      end

      # �����֥������Ȥ�ref�����ɤ��֤�
      @cIMCode.add_element(@cTS.gc_obj_ref_fmp(nIndex))

      # �ХꥢƱ��
      @cIMCode.set_condition_level(IMC_CONDITION_SYNC)
      @cIMCode.add_element(@cTS.gc_barrier_sync(nIndex))

      # ���Υ���ǥ������ػ��֤κ������ʤ��
      if (@cTS.exist_post_timetick(nIndex) == true)
        @cIMCode.add_element(@cTS.gc_tick_gain_fmp(nIndex))
      end

      # ���ξ��֤˹Ԥ����Υᥤ�󥿥���������Υ����ɤ��֤�
      @cIMCode.add_element(@cTS.gc_post_maintask_set(nIndex, @cTS.exist_post_timetick(nIndex)))
    end

    #================================================================
    # ��  ��: GCOV�������ѤΥ����Х�����/��λ�롼����Υ����ɤ���
    #         ������
    #================================================================
    def build_gcov_ini_ter_rtn()
      cElement = IMCodeElement.new(:common)
      # ����ñ�����(bootcnt��0����)
      cElement.set_proc_unit(FNC_GCOV_INI, TTG_MAIN_BOOTCNT)
      cElement.set_proc_unit(FNC_GCOV_TER, TTG_MAIN_BOOTCNT)

      # �إå�����
      cElement.set_header(FNC_GCOV_INI, TSR_OBJ_INIRTN)
      cElement.set_header(FNC_GCOV_TER, TSR_OBJ_TERRTN)

      # ����ե����ե��������
      cElement.set_config("#{API_ATT_INI}({#{KER_TA_NULL}, 0, #{FNC_GCOV_INI}});", IMC_NO_CLASS)
      cElement.set_config("#{API_ATT_TER}({#{KER_TA_NULL}, 0, #{FNC_GCOV_TER}});", IMC_NO_CLASS)

      # GCOV������Ϣ���
      hGcovIniRtn = {:id => FNC_GCOV_INI, :prcid => @cConf.get_main_prcid(), :bootcnt => TTG_MAIN_BOOTCNT}
      hGcovTerRtn = {:id => FNC_GCOV_TER, :prcid => @cConf.get_main_prcid(), :bootcnt => TTG_MAIN_BOOTCNT}
      cElement.set_code(hGcovIniRtn, FNC_GCOV_C_PAUSE)
      cElement.set_code(hGcovTerRtn, FNC_GCOV_C_RESUME)
      cElement.set_code(hGcovTerRtn, FNC_GCOV_C_DUMP)

      @cIMCode.add_element(cElement)
    end

    #================================================================
    # ��  ��: �ƥ��ȥ饤�֥�����ѿ���������ѤΥ����Х������롼��
    #         ��Υ����ɤ���������
    #================================================================
    def build_initialize_test_lib_ini_rtn()
      cElement = IMCodeElement.new(:common)
      # ����ñ�����(bootcnt��0����)
      cElement.set_proc_unit(FNC_TEST_LIB_INI, TTG_MAIN_BOOTCNT)

      # �إå�����
      cElement.set_header(FNC_TEST_LIB_INI, TSR_OBJ_INIRTN)

      # ����ե����ե��������
      cElement.set_config("#{API_ATT_INI}({#{KER_TA_NULL}, 0, #{FNC_TEST_LIB_INI}});", IMC_NO_CLASS)

      # �ƥ��ȥ饤�֥�����ѿ������
      hIniRtn = {:id => FNC_TEST_LIB_INI, :prcid => @cConf.get_main_prcid(), :bootcnt => TTG_MAIN_BOOTCNT}
      cElement.set_code(hIniRtn, FNC_INITIALIZE_TEST_LIB)

      @cIMCode.add_element(cElement)
    end

    #================================================================
    # ��  ��: FMP�Ǥϥ����Х������롼�������Ѥ��뤿�Ჿ�⤷�ʤ�
    #================================================================
    def build_main_task_gcov_start()
    end

    #================================================================
    # ��  ��: FMP�Ǥ�Ŭ�ڤʥץ��å��إᥤ�󥿥�����ޥ����졼�����
    #         ���Ƥ������ߤ�ȯ��������
    #================================================================
    def build_int_raise(cElement, snIntNo, nPrcid)
      check_class(IMCodeElement, cElement)    # �������
      check_class([String, Integer], snIntNo) # ������ֹ�
      check_class(Integer, nPrcid)            # �ץ��å�ID

      nMainPrcid = @cConf.get_main_prcid()

      # �ᥤ�󥿥������о�IntHdr/ISR�Υץ��å����ۤʤ���ϥᥤ�󥿥������ư
      if (nMainPrcid != nPrcid)
        cElement.set_syscall(@cIMCode.hMainTask, "#{API_MIG_TSK}(#{TTG_TSK_SELF}, #{nPrcid})")
      end

      cElement.set_code(@cIMCode.hMainTask, "#{FNC_INT_RAISE}(#{snIntNo})")

      # dis_int�򥵥ݡ��Ȥ��Ƥ��ʤ���硤�����ǥᥤ��ץ��å������
      if ((nMainPrcid != nPrcid) && (@cConf.get_api_support_dis_int() == false))
        cElement.set_syscall(@cIMCode.hMainTask, "#{API_MIG_TSK}(#{TTG_TSK_SELF}, #{nMainPrcid})")
      end
    end

    #================================================================
    # ��  ��: FMP�Ǥ�Ŭ�ڤʥץ��å��إᥤ�󥿥�����ޥ����졼�����
    #         ���Ƥ���dis_int��¹Ԥ���
    #================================================================
    def build_dis_int(cElement, snIntNo, nPrcid)
      check_class(IMCodeElement, cElement)    # �������
      check_class([String, Integer], snIntNo) # ������ֹ�
      check_class(Integer, nPrcid)            # �ץ��å�ID

      nMainPrcid = @cConf.get_main_prcid()

      cElement.set_syscall(@cIMCode.hMainTask, "#{API_DIS_INT}(#{snIntNo})")

      # �Ǹ��ɬ���ᥤ��ץ��å������
      if (nMainPrcid != nPrcid)
        cElement.set_syscall(@cIMCode.hMainTask, "#{API_MIG_TSK}(#{TTG_TSK_SELF}, #{nMainPrcid})")
      end
    end

  end
end
