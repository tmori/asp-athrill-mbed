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
#  $Id: ASPBuilder.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#
require "common/bin/CommonModule.rb"
require "bin/builder/ProfileBuilder.rb"

module TTG

  #==================================================================
  # ���饹̾: ASPBuilder
  # ��    ��: �ƥ��ȥ��ʥꥪ���Ѥ�����֥����ɤ��������륯�饹
  #==================================================================
  class ASPBuilder < ProfileBuilder
    include CommonModule

    #================================================================
    # ��  ��: ���󥹥ȥ饯��
    #================================================================
    def initialize()
      super()

      # ASP�Ǥ�GCOV��������
      if (@cConf.enable_gcov?())
        # GCOV�����Ѵؿ����
        @cIMCode.add_gcov_resume_asp()
        @cIMCode.add_gcov_pause_asp()
      end

      # ��������ؿ�������С������ƥ���ﹹ����ǧ�ؿ������
      if (@cConf.get_func_time())
        @cIMCode.add_gain_tick_asp()
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
        @cIMCode.add_element(@cTS.gc_pre_task_scobj_waiting())
      end


      #
      # �¹Ծ��֤ǤϤʤ�������������ƥ����Ȥ�����
      #

      # �Ԥ�����(���꡼�ס��ǥ��쥤)�Υ�����������
      # ������Ԥ����֤��Ԥ�����(���꡼�ס��ǥ��쥤)������
      if (@cTS.exist_pre_task_waiting() == true)
        @cIMCode.add_element(@cTS.gc_pre_task_waiting())
      end

      # �����Ԥ�������Ԥ����֤Υ�����������
      # ������Ԥ����֤ζ����Ԥ����֤�����
      if (@cTS.exist_pre_task_suspended() == true)
        @cIMCode.add_element(@cTS.gc_pre_task_suspended())
      end

      # �¹Բ�ǽ���֤Υ�����������
      if (@cTS.exist_pre_task_ready() == true)
        @cIMCode.add_element(@cTS.gc_pre_task_ready())
      end


      #
      # ��������α�㳰�װ�������(running,dormant,���֥��������Ԥ��ʳ��Υ�����)
      #
      if (@cTS.exist_pre_task_tex_pndptn() == true)
        @cIMCode.add_element(@cTS.gc_pre_task_tex_pndptn())
      end


      #
      # ����ͥ���٤Ƚ��ͥ���٤��ۤʤ륿����������(running,dormant�ʳ��Υ�����)
      #
      if (@cTS.exist_pre_task_pri_chg() == true)
        @cIMCode.add_element(@cTS.gc_pre_task_pri_chg())
      end


      #
      # ư����֡�Txxx_STA�ˤΥ����।�٥�ȥϥ�ɥ������
      #
      if (@cTS.exist_time_event_sta() == true)
        @cIMCode.add_element(@cTS.gc_pre_time_event_sta())
      end


      #
      # ���ľ��֤γ���ߤ�����(ena_int�򥵥ݡ��Ȥ��Ƥ�����Τ�)
      #
      if ((@cTS.exist_interrupt_ena() == true) && (@cConf.get_api_support_ena_int() == true))
        @cIMCode.add_element(@cTS.gc_pre_interrupt_ena())
      end


      #
      # �¹Ծ��֤Υ���������ƥ����Ȥ�����
      # �ʥ��������������㳰��
      #
      if (@cTS.exist_task_running() == true)
        # ��ư���֡�ACTIVATE�ˤΥ������㳰�����ʤ����
        if (@cTS.exist_pre_task_texhdr_activate() == false)
          @cIMCode.add_element(@cTS.gc_pre_task_running())
        # ��ư���֡�ACTIVATE�ˤΥ������㳰��������
        else
          @cIMCode.add_element(@cTS.gc_pre_task_texhdr_activate())
        end
      end


      # �ǥ����ѥå��ػߤ�����
      if (@cTS.check_dis_dsp() == true)
        @cIMCode.add_element(@cTS.gc_pre_dis_dsp())
      end


      # �����ͥ���٥ޥ���������
      # (�󥿥�������ư���뤳�Ȥˤ�ä��ѹ����줿�����ѹ����ʤ�)
      if (@cTS.check_chg_ipm() == true)
        @cIMCode.add_element(@cTS.gc_pre_set_ipm())
      end


      #
      # ��ư���֡�ACTIVATE�ˤ��󥿥�������ƥ����Ȥ�����
      #
      if (@cTS.exist_nontask_activate() == true)
        @cIMCode.add_element(@cTS.gc_pre_nontask_activate())
      end


      #
      # �Ԥ����֤ˤ��Ƥ����¹Բ�ǽ���֤Υ������ε���
      #
      if (@cTS.exist_pre_task_ready() == true)
        @cIMCode.add_element(@cTS.gc_pre_task_ready_porder())
      end


      #
      # ��ư�������׵ᥭ�塼���󥰤�����
      #
      if (@cTS.exist_task_queueing() == true)
        @cIMCode.add_element(@cTS.gc_pre_task_queueing())
      end


      #
      # CPU��å����֤�����
      #
      if (@cTS.check_cpu_loc() == true)
        @cIMCode.add_element(@cTS.gc_pre_cpu_loc())
      end


      #
      # �����ֺ��������ǡ��¹���ν���ñ�̤���
      # �����֥������Ȥ�ref�����ɤ�����
      #
      @cIMCode.add_element(@cTS.gc_obj_ref())


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
        @cIMCode.add_element(@cTS.gc_do(nIndex))
      end

      # ���Υ���ǥ������ǵ�ư����ACTIVATE���󥿥�����¸�ߤ����硤��ư���Ԥ�
      @cIMCode.add_element(@cTS.gc_wait_non_task_activate(nIndex))
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
      @cIMCode.add_element(@cTS.gc_obj_ref(nIndex))

      # �ǥ����ѥå���α���֤�ͥ���٤���ž�������֤�������ready�Υ�����������slp_tsk����
      # (�ǥ����ѥå��Ǽ¹Ծ��֤Υ��������Ѥ�äƤ�slp_tsk�ˤ�äơ�cRunning���¹Ծ��֤ˤʤ�)
      if ((@cTS.exist_nontask_activate(nIndex) == true) ||
          (@cTS.check_cpu_loc(nIndex) == true) ||
          (@cTS.check_dis_dsp(nIndex) == true) ||
          (@cTS.check_chg_ipm(nIndex) == true))
        @cIMCode.add_element(@cTS.gc_lastpost_ready_sleep())
      end

      #
      # ��λ����
      # 

      # �¹Ծ��֤ν���ñ�̤���CPU��å�����
      if (@cTS.check_cpu_loc(nIndex) == true)
        @cIMCode.add_element(@cTS.gc_lastpost_cpu_unl())
      end

      # �¹Ծ��֤Υ���������ư����(ACTIVATE)���󥿥����������硤�ᥤ�󥿥����򵯤���
      if (@cTS.exist_task_running(nIndex) == true || @cTS.exist_nontask_activate(nIndex) == true)
        @cIMCode.add_element(@cTS.gc_lastpost_maintask_wup(nIndex))
      end

      # �ǥ����ѥå��ػߤβ��
      if (@cTS.check_dis_dsp(nIndex) == true)
        @cIMCode.add_element(@cTS.gc_lastpost_ena_dsp())
      end

      # �����ͥ���٥ޥ����ν����
      if (@cTS.check_chg_ipm(nIndex) == true)
        @cIMCode.add_element(@cTS.gc_lastpost_set_ini_ipm())
      end

      #
      # ���λ����ǥᥤ�󥿥������¹Ծ��֤ȤʤäƤ���
      #

      # ����ư��Ǥ��̲᤹�뤳�ȤΤʤ���������å��ݥ���Ȥ�ƥ��������ɲ�
      @cIMCode.add_element(@cTS.gc_checkpoint_zero())

      # ư����֡�Txxx_STA�ˤΥ����।�٥�ȥϥ�ɥ����߽���
      if (@cTS.exist_time_event_sta(nIndex) == true)
        @cIMCode.add_element(@cTS.gc_lastpost_time_event_stp())
      end

      #
      # ���ľ��֤γ���ߤζػ߽���(dis_int�򥵥ݡ��Ȥ��Ƥ�����Τ�)
      #
      if ((@cTS.exist_interrupt_ena(nIndex) == true) && (@cConf.get_api_support_dis_int() == true))
        @cIMCode.add_element(@cTS.gc_lastpost_interrupt_dis())
      end

      # ��ư�׵ᥭ�塼���󥰤ν����
      if (@cTS.exist_task_queueing(nIndex) == true)
        @cIMCode.add_element(@cTS.gc_lastpost_task_can_queueing())
      end

      # �ᥤ�󥿥����Ǥ��٤ƤΥ�������ter_tsk������
      @cIMCode.add_element(@cTS.gc_lastpost_all_task_ter())

    end


    #================================================================
    # ��  ��: post_condition���������뤿�����֥����ɤ���������
    #================================================================
    def build_post_condition(nIndex)
      check_class(Integer, nIndex)  # do/post�Υ��������ֹ�

      # post_condition�Υϥå�����ɲä���
      @cIMCode.set_condition_level(TSR_LBL_POST + "_#{@cTS.get_seqnum(nIndex)}_#{@cTS.get_timetick(nIndex)}")

      # �����֥������Ȥ�ref�����ɤ��֤�
      @cIMCode.add_element(@cTS.gc_obj_ref(nIndex))

      # ���Υ���ǥ������ػ��֤κ������ʤ��
      if (@cTS.exist_post_timetick(nIndex) == true)
        @cTS.get_post_time(nIndex).times{
          @cIMCode.add_element(@cTS.gc_tick_gain(nIndex))
        }
      end

      # ���ξ��֤˹Ԥ����Υᥤ�󥿥���������Υ����ɤ��֤�
      @cIMCode.add_element(@cTS.gc_post_maintask_set(nIndex, @cTS.exist_post_timetick(nIndex)))

    end

    #================================================================
    # ��  ��: �ᥤ�󥿥�����GCOV�����򳫻Ϥ���
    #================================================================
    def build_main_task_gcov_start()
      cElement = IMCodeElement.new(:common)
      cElement.set_code(@cIMCode.hMainTask, "#{TTG_NL}#{TTG_TB}#{FNC_GCOV_C_PAUSE}")
      @cIMCode.add_element(cElement)
    end

    #================================================================
    # ��  ��: �ᥤ�󥿥����������ߤ�ȯ��������
    #================================================================
    def build_int_raise(cElement, snIntNo, nPrcid)
      check_class(IMCodeElement, cElement)    # �������
      check_class([String, Integer], snIntNo) # ������ֹ�
      check_class(Integer, nPrcid, true)      # �ץ��å�ID(ASP�Ǥ��Ի���)

      cElement.set_code(@cIMCode.hMainTask, "#{FNC_INT_RAISE}(#{snIntNo})")
    end

    #================================================================
    # ��  ��: �ᥤ�󥿥�����dis_int��¹Ԥ���
    #================================================================
    def build_dis_int(cElement, snIntNo, nPrcid)
      check_class(IMCodeElement, cElement)    # �������
      check_class([String, Integer], snIntNo) # ������ֹ�
      check_class(Integer, nPrcid, true)      # �ץ��å�ID(ASP�Ǥ��Ի���)

      cElement.set_syscall(@cIMCode.hMainTask, "#{API_DIS_INT}(#{snIntNo})")
    end

  end
end
