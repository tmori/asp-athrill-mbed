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
require "common/bin/CommonModule.rb"
require "common/bin/Config.rb"
require "common/bin/test_scenario/PreCondition.rb"
require "common/bin/test_scenario/Do_PostCondition.rb"
require "ttc/bin/test_scenario/TestScenario.rb"
require "ttj/bin/test_scenario/TestScenario.rb"
require "bin/builder/fmp_builder/test_scenario/TestScenario.rb"

#=====================================================================
# CommonModule
#=====================================================================
module CommonModule
  #===================================================================
  # ���饹̾: TestScenario
  # ��    ��: PreCondition��Do��PostCondition�Υǡ���������
  #===================================================================
  class TestScenario
    include CommonModule

    attr_reader :sTestID, :hVariation, :cPreCondition, :aDo_PostCondition, :bGainTime, :bGcovAll

    #=================================================================
    # ��  ��: ���󥹥ȥ饯��
    #=================================================================
    def initialize(sTestID, hScenario)
      check_class(Object, sTestID, true)    # �ƥ���ID
      check_class(Object, hScenario, true)  # pre��do��post���ʥꥪ

      @cConf        = Config.new()  # ����ե����μ���
      @hVariation   = {}            # �Хꥨ����������
      @bGainTime    = nil           # ���ֽ���
      @bHasTimeTick = false         # ������ƥ��å�����Ĥ�Ƚ���ѥե饰
      @sTestID      = sTestID       # �ƥ���ID
      @sNote        = nil           # ������

      # ��¤�����å�
      basic_check(sTestID, hScenario)

      # ������ƥ��å�����Ĥ�Ƚ��
      hMacro = @cConf.get_macro()
      hScenario.each{|sCondition, shCondition|
        if (sCondition =~ TSR_REX_PRE_DO || sCondition =~ TSR_REX_PRE_POST)
          if (has_timetick?(shCondition))
            @bHasTimeTick = true
            break
          end
        end
      }

      # variation��Ǽ
      if (hScenario[TSR_LBL_VARIATION].nil?())
        @hVariation = {}
      else
        @hVariation = hScenario[TSR_LBL_VARIATION]
      end
      # gcov_all
      if (@hVariation[TSR_PRM_GCOV_ALL].nil?())
        @bGcovAll = false
      else
        @bGcovAll = @hVariation[TSR_PRM_GCOV_ALL]
      end

      # note��Ǽ
      @sNote = hScenario[TSR_LBL_NOTE]

      # pre_condition����
      @cPreCondition = PreCondition.new(sTestID, hScenario[TSR_LBL_PRE])
      @cPreCondition.set_gcov_all_flg(@bGcovAll)

      # do��post_condition����(do��post�ϰ��˽���)
      @aDo_PostCondition = []

      # ��¤������
      hScenario = fix_structure(hScenario)

      # ���������ֹ����
      aSeqNumList = []
      hScenario.each_key{|sCondition|
        if (sCondition =~ TSR_REX_DO)
          aSeqNumList.push($1.to_i())
        end
      }
      aSeqNumList = aSeqNumList.sort()

      # ��������do��post�����
      aSeqNumList.each{|nSeqNum|
        sSeqDo   = "#{TSR_UNS_DO}#{nSeqNum}"
        sSeqPost = "#{TSR_UNS_POST}#{nSeqNum}"
        # �������������ֹ�Ǥ���������ƥ��å�����
        aTimeTickList = hScenario[sSeqDo].keys()
        aTimeTickList.concat(hScenario[sSeqPost].keys())
        aTimeTickList = aTimeTickList.uniq().sort()

        aTimeTickList.each{|nTimeTick|
          hScenarioDo   = hScenario["#{TSR_UNS_DO}#{nSeqNum}"][nTimeTick]
          hScenarioPost = hScenario["#{TSR_UNS_POST}#{nSeqNum}"][nTimeTick]

          cObj = Do_PostCondition.new(sTestID, hScenarioDo, hScenarioPost, nSeqNum, nTimeTick, @cPreCondition)
          cObj.set_gcov_all_flg(@bGcovAll)
          @aDo_PostCondition.push(cObj)
        }
      }
    end

    #=================================================================
    # ��  ��: �ƥ��ȥ��ʥꥪ�ι�¤��������
    #=================================================================
    def fix_structure(hScenario)
      check_class(Hash, hScenario)  # �ƥ��ȥ��ʥꥪ

      hResult = {}
      hScenario.each{|sCondition, shCondition|
        case sCondition
        when TSR_LBL_PRE, TSR_LBL_VARIATION, TSR_LBL_NOTE
          hResult[sCondition] = shCondition
        when TSR_REX_PRE_DO
          sSeq    = "#{TSR_UNS_DO}#{$1.to_i()}"
          hResult = fix_condition(hResult, shCondition, sSeq)
        when TSR_REX_PRE_POST
          sSeq    = "#{TSR_UNS_POST}#{$1.to_i()}"
          hResult = fix_condition(hResult, shCondition, sSeq)
        else
          abort(ERR_MSG % [__FILE__, __LINE__])
        end
      }

      return hResult  # [Hash]�������줿�ƥ��ȥ��ʥꥪ
    end

    #=================================================================
    # ��  ��: ����ǥ������ι�¤��������
    #=================================================================
    def fix_condition(hScenario, hCondition, sSeq)
      check_class(Hash, hScenario)         # ���ʥꥪ
      check_class(Hash, hCondition, true)  # ����ǥ������
      check_class(String, sSeq)            # ���������ֹ�

      hResult = hScenario.dup()
      hMacro = @cConf.get_macro()
      # ������ƥ��å�����
      if (has_timetick?(hCondition))
        hResult[sSeq] = {}
        hCondition.each{|nTimeTick, hBlock|
          nTimeTick = parse_value(nTimeTick, hMacro)
          hResult[sSeq][nTimeTick] = hBlock
        }
      # ������ƥ��å�̵����0�ƥ��å��䴰��
      else
        hResult[sSeq] = {}
        hResult[sSeq][0] = hCondition
      end

      return hResult  # [Hash]�������줿����ǥ������
    end

    #=================================================================
    # ��  ��: �ƥ���ǥ�����������
    #=================================================================
    def init_conditions()
      aConditions = get_all_condition()
      aConditions.each{|cCondition|
        cCondition.init_instance_variables()
      }
    end

    #=================================================================
    # ��  ��: ���������ֹ���֤�
    #=================================================================
    def get_seqnum(nIndex)
      check_class(Integer, nIndex)  # �����ܤ�do_post��  # �����ܤ�do_post��

      return @aDo_PostCondition[nIndex].nSeqNum  # [Integer]���������ֹ�
    end

    #=================================================================
    # ��  ��: ������ƥ��å��ֹ���֤�
    #=================================================================
    def get_timetick(nIndex)
      check_class(Integer, nIndex)  # �����ܤ�do_post��  # �����ܤ�do_post��

      return @aDo_PostCondition[nIndex].nTimeTick  # [Integer]������ƥ��å��ֹ�
    end

    #=================================================================
    # ��  ��: pre_condition�ǿʤ���֤�����
    #=================================================================
    def set_pre_gain_tick()
      @cPreCondition.set_pre_gain_tick()
    end

    #=================================================================
    # ��  ��: �ǥ����ѥå��ػߤγ�ǧ(�ǥ����ѥå��ػ߾��֤ξ���true)
    #=================================================================
    def check_dis_dsp(nIndex = nil)
      check_class(Integer, nIndex, true)  # �����ܤ�do_post��  # �����ܤ�do_post��

      if (nIndex.nil?())
        return @cPreCondition.check_dis_dsp()  # [Bool]�ǥ����ѥå��ػ߾���
      else
        return @aDo_PostCondition[nIndex].check_dis_dsp()  # [Bool]�ǥ����ѥå��ػ߾���
      end
    end

    #=================================================================
    # ��  ��: �����ͥ���٥ޥ����γ�ǧ(������ǤϤʤ�����true)
    #=================================================================
    def check_chg_ipm(nIndex = nil)
      check_class(Integer, nIndex, true)  # �����ܤ�do_post��  # �����ܤ�do_post��

      if (nIndex.nil?())
        return @cPreCondition.check_pre_need_chg_ipm()  # [Bool]�����ͥ���٥ޥ���
      else
        return @aDo_PostCondition[nIndex].check_chg_ipm()  # [Bool]�����ͥ���٥ޥ���
      end
    end

    #=================================================================
    # ��  ��: CPU��å����֤γ�ǧ(CPU��å����֤ξ���true)
    #=================================================================
    def check_cpu_loc(nIndex = nil)
      check_class(Integer, nIndex, true)  # �����ܤ�do_post��  # �����ܤ�do_post��

      if (nIndex.nil?())
        return @cPreCondition.check_cpu_loc()  # [Bool]CPU��å�����
      else
        return @aDo_PostCondition[nIndex].check_cpu_loc()  # [Bool]CPU��å�����
      end
    end

    #=================================================================
    # ��  ��: �Ǹ��post_condition����ǧ
    #=================================================================
    def check_lastpost_condition(nIndex)
      check_class(Integer, nIndex)  # �����ܤ�do_post��

      if (@aDo_PostCondition[TTG_IDX_LAST] == @aDo_PostCondition[nIndex])
        return true  # [Bool]�Ǹ��post_condition��
      end

      return false  # [Bool]�Ǹ��post_condition��
    end

    #=================================================================
    # ��  ��: �ᥤ�󥿥���ID���ץ��å�ID����ư��������
    #=================================================================
    def get_main_task_proc()
      return @cPreCondition.get_proc_unit_info()  # [Hash]�ᥤ�󥿥����ξ���
    end

    #=================================================================
    # ��  ��: �������ο����֤�
    #=================================================================
    def get_stack_num()
      return @cPreCondition.hTask.size()  # [Integer]�������ο�
    end

    #=================================================================
    # ��  ��: ���Ƥν���ñ��̾�Ȥ��줾��κǽ�Ū�ʵ�ư��������
    #=================================================================
    def get_proc_units(cElement)
      check_class(IMCodeElement, cElement)  # �����ɤ��ɲä��륨�����

      @aDo_PostCondition[TTG_IDX_LAST].get_proc_units(cElement)
    end

    #=================================================================
    # ��  ��: ���ߤξ��֤������֤Ȥλ��֤κ������
    #=================================================================
    def get_post_time(nIndex)
      check_class(Integer, nIndex)  # �����ܤ�do_post��

      return @aDo_PostCondition[nIndex + 1].nTimeTick - @aDo_PostCondition[nIndex].nTimeTick  # [Integer]���ߤξ��֤������֤Ȥλ��֤κ�
    end

    #=================================================================
    # ��  ��: �������㳰�������ľ��֤Υ�����̵ͭ��ǧ
    #=================================================================
    def exist_pre_task_tex_ena()
      return @cPreCondition.exist_pre_task_tex_ena()  # [Bool]�������㳰�������ľ��֤Υ�������¸�ߤ��뤫
    end

    #=================================================================
    # ��  ��: ACTIVATE�Ǥ��륿�����㳰�ϥ�ɥ��̵ͭ��ǧ
    #=================================================================
    def exist_pre_task_texhdr_activate()
      return @cPreCondition.exist_pre_task_texhdr_activate()  # [Bool]ACTIVATE�Ǥ��륿�����㳰�ϥ�ɥ餬¸�ߤ��뤫
    end

    #=================================================================
    # ��  ��: �Ԥ����֥������Ȥ�̵ͭ��ǧ
    #=================================================================
    def exist_pre_scobj_data()
      return @cPreCondition.exist_pre_scobj_data()  # [Bool]�Ԥ����֥������Ȥ�¸�ߤ��뤫
    end

    #=================================================================
    # ��  ��: ���֥��������Ԥ��Υ�������̵ͭ��ǧ
    #=================================================================
    def exist_pre_task_scobj_waiting()
      return @cPreCondition.exist_pre_task_scobj_waiting()  # [Bool]���֥��������Ԥ��Υ�������¸�ߤ��뤫
    end

    #=================================================================
    # ��  ��: �Ԥ�����(���꡼�ס��ǥ��쥤)�Υ�������̵ͭ��ǧ
    #         ������Ԥ����֤��Ԥ�����(���꡼�ס��ǥ��쥤)��ޤ��
    #=================================================================
    def exist_pre_task_waiting()
      return @cPreCondition.exist_pre_task_waiting()  # [Bool]�Ԥ����֤Υ�������¸�ߤ��뤫
    end

    #=================================================================
    # ��  ��: �����Ԥ�������Ԥ����֤Υ�������̵ͭ��ǧ
    #         ������Ԥ����֤ζ����Ԥ���ޤ��
    #=================================================================
    def exist_pre_task_suspended()
      return @cPreCondition.exist_pre_task_suspended()  # [Bool]�����Ԥ�������Ԥ����֤Υ�������¸�ߤ��뤫
    end

    #=================================================================
    # ��  ��: �¹Բ�ǽ���֤Υ�������̵ͭ��ǧ
    #=================================================================
    def exist_pre_task_ready()
      return @cPreCondition.exist_pre_task_ready()  # [Bool]�¹Բ�ǽ���֤Υ�������¸�ߤ��뤫
    end

    #=================================================================
    # ��  ��: ����ͥ���٤Ƚ��ͥ���٤��ۤʤ륿������̵ͭ��ǧ
    #=================================================================
    def exist_pre_task_pri_chg()
      return @cPreCondition.exist_pre_task_pri_chg()  # [Bool]����ͥ���٤Ƚ��ͥ���٤��ۤʤ륿������¸�ߤ��뤫
    end

    #=================================================================
    # ��  ��: ��ư�������׵ᥭ�塼���󥰤�����򤷤Ƥ��륿������̵ͭ��
    #         ǧ
    #=================================================================
    def exist_task_queueing(nIndex = nil)
      check_class(Integer, nIndex, true)  # �����ܤ�do_post��

      if (nIndex.nil?())
        return @cPreCondition.exist_task_queueing()  # [Bool]��ư�������׵ᥭ�塼���󥰤�����򤷤Ƥ��륿������¸�ߤ��뤫
      else
        return @aDo_PostCondition[TTG_IDX_LAST].exist_task_queueing()  # [Bool]��ư�������׵ᥭ�塼���󥰤�����򤷤Ƥ��륿������¸�ߤ��뤫
      end
    end

    #=================================================================
    # ��  ��: ��������α�㳰�װ������ꤵ��Ƥ��륿�����㳰��̵ͭ��ǧ
    #=================================================================
    def exist_pre_task_tex_pndptn()
      return @cPreCondition.exist_pre_task_tex_pndptn()  # [Bool]��������α�㳰�װ������ꤵ��Ƥ��륿�����㳰��¸�ߤ��뤫
    end

    #=================================================================
    # ��  ��: ư����֡�Txxx_STA�ˤΥ����।�٥�ȥϥ�ɥ��̵ͭ��ǧ
    #=================================================================
    def exist_time_event_sta(nIndex = nil)
      check_class(Integer, nIndex, true)  # �����ܤ�do_post��

      if (nIndex.nil?())
        return @cPreCondition.exist_time_event_sta()  # [Bool]ư����֤Υ����।�٥�ȥϥ�ɥ餬¸�ߤ��뤫
      else
        return @aDo_PostCondition[TTG_IDX_LAST].exist_time_event_sta()  # [Bool]ư����֤Υ����।�٥�ȥϥ�ɥ餬¸�ߤ��뤫
      end
    end

    #=================================================================
    # ��  ��: ���ľ��֤γ���ߥϥ�ɥ顤����ߥ����ӥ��롼�����̵ͭ��
    #         ǧ
    #=================================================================
    def exist_interrupt_ena(nIndex = nil)
      check_class(Integer, nIndex, true)  # �����ܤ�do_post��

      if (nIndex.nil?())
        return @cPreCondition.exist_interrupt_ena()  # [Bool]���ľ��֤γ���ߥϥ�ɥ顤����ߥ����ӥ��롼����¸�ߤ��뤫
      else
        return @aDo_PostCondition[TTG_IDX_LAST].exist_interrupt_ena()  # [Bool]���ľ��֤γ���ߥϥ�ɥ顤����ߥ����ӥ��롼����¸�ߤ��뤫
      end
    end

    #=================================================================
    # ��  ��: �¹Ծ��֤Υ�������̵ͭ��ǧ
    #=================================================================
    def exist_task_running(nIndex = nil)
      check_class(Integer, nIndex, true)  # �����ܤ�do_post��

      if (nIndex.nil?())
        return @cPreCondition.exist_task_running()  # [Bool]�¹Ծ��֤Υ�������¸�ߤ��뤫
      else
        return @aDo_PostCondition[TTG_IDX_LAST].exist_task_running()  # [Bool]�¹Ծ��֤Υ�������¸�ߤ��뤫
      end
    end

    #=================================================================
    # ��  ��: ��ư����󥿥�����̵ͭ��ǧ
    #=================================================================
    def exist_nontask_activate(nIndex = nil)
      check_class(Integer, nIndex, true)  # �����ܤ�do_post��

      if (nIndex.nil?())
        return @cPreCondition.exist_nontask_activate()  # [Bool]��ư����󥿥�����¸�ߤ��뤫
      else
        return @aDo_PostCondition[TTG_IDX_LAST].exist_nontask_activate()  # [Bool]��ư����󥿥�����¸�ߤ��뤫
      end
    end

    #=================================================================
    # ��  ��: ���֤�ʤ��ɬ�פ����뤫��ǧ
    #=================================================================
    def exist_post_timetick(nIndex)
      check_class(Integer, nIndex)  # �����ܤ�do_post��

      if (@aDo_PostCondition[nIndex].nTimeTick != @aDo_PostCondition[nIndex + 1].nTimeTick)
        return true  # [Bool]���֤�ʤ��ɬ�פ����뤫
      else
        return false  # [Bool]���֤�ʤ��ɬ�פ����뤫
      end
    end

    #=================================================================
    # ��  ��: do���������äƤ����true�������ǤϤʤ����false���֤�
    #=================================================================
    def check_do_info(nIndex)
      check_class(Integer, nIndex)  # �����ܤ�do_post��

      if (@aDo_PostCondition[nIndex].hDo.empty?())
        return false  # [Bool]do�����꤬����Ƥ��뤫
      else
        return true  # [Bool]do�����꤬����Ƥ��뤫
      end
    end

    #=================================================================
    # ��  ��: �����Х�/�������ѿ���������뤿��Υ����ɤ����ꤹ��
    #=================================================================
    def gc_global_local_var(cElement)
      check_class(IMCodeElement, cElement)  # �����ɤ��ɲä��륨�����

      @cPreCondition.gc_global_local_var(cElement)
    end

    #=================================================================
    # ��  ��: �إå����ե�����˽��Ϥ��륳���ɤ����ꤹ��
    #=================================================================
    def gc_header(cElement)
      check_class(IMCodeElement, cElement)  # �����ɤ��ɲä��륨�����

      @cPreCondition.gc_header(cElement)
    end

    #=================================================================
    # ��  ��: ����ե����ե�����˽��Ϥ��륳���ɤ����ꤹ��
    #=================================================================
    def gc_config(cElement)
      check_class(IMCodeElement, cElement)  # �����ɤ��ɲä��륨�����

      @cPreCondition.gc_config(cElement)
    end

    #=================================================================
    # ��  ��: �������㳰�������ľ��֤ˤ��륳���ɤ��֤�
    #=================================================================
    def gc_pre_task_tex_ena()
      return @cPreCondition.gc_pre_task_tex_ena()  # [IMCodeElement]�������㳰�������ľ��֤ˤ��륳����
    end

    #=================================================================
    # ��  ��: �������㳰�����򵯤��������ɤ��֤�
    #=================================================================
    def gc_pre_task_texhdr_activate()
      return @cPreCondition.gc_pre_task_texhdr_activate()  # [IMCodeElement]�������㳰�����򵯤���������
    end

    #=================================================================
    # ��  ��: �Ԥ����֥������Ȥν������Τ���Υ����ɤ��֤�
    #=================================================================
    def gc_pre_scobj_data()
      return @cPreCondition.gc_pre_scobj_data()  # [IMCodeElement]�Ԥ����֥������Ȥν������Τ���Υ�����
    end

    #=================================================================
    # ��  ��: ���֥��������Ԥ�����������Τ���Υ����ɤ��֤�
    #=================================================================
    def gc_pre_task_scobj_waiting()
      return @cPreCondition.gc_pre_task_scobj_waiting()  # [IMCodeElement]���֥��������Ԥ�����������Τ���Υ�����
    end

    #=================================================================
    # ��  ��: �Ԥ�����(���꡼�ס��ǥ��쥤)�Υ������ȡ�����Ԥ����֤�
    #         �Ԥ����֤Υ����������ꤹ�륳���ɤ��֤�
    #         ������Ԥ����֤��Ԥ�����(���꡼�ס��ǥ��쥤)��ޤ��
    #=================================================================
    def gc_pre_task_waiting()
      return @cPreCondition.gc_pre_task_waiting()  # [IMCodeElement]�Ԥ����֡�����Ԥ����֤Υ����������ꤹ�륳����
    end

    #=================================================================
    # ��  ��: �����Ԥ�������Ԥ����֤����ꤹ�륳���ɤ��֤�
    #         ������Ԥ����֤ζ����Ԥ���ޤ��
    #=================================================================
    def gc_pre_task_suspended()
      return @cPreCondition.gc_pre_task_suspended()  # [IMCodeElement]�����Ԥ�������Ԥ����֤����ꤹ�륳����
    end

    #=================================================================
    # ��  ��: �¹Բ�ǽ���֤Υ����������ꤹ�륳���ɤ��֤�
    #         �ºݤϵ���������ˡ���Χ���Ԥ����֤ˤ��Ƥ���
    #         �ʤ��λ����ǡ��������㳰���������Ĥ���Ƥ��륿�����ϡ�
    #=================================================================
    def gc_pre_task_ready()
      return @cPreCondition.gc_pre_task_ready()  # [IMCodeElement]�¹Բ�ǽ���֤Υ����������ꤹ�륳����
    end

    #=================================================================
    # ��  ��: ��������α�㳰�װ������ꤹ�륳���ɤ��֤�
    #=================================================================
    def gc_pre_task_tex_pndptn()
      return @cPreCondition.gc_pre_task_tex_pndptn()  # [IMCodeElement]��������α�㳰�װ������ꤹ�륳����
    end

    #=================================================================
    # ��  ��: ư����֡�Txxx_STA�ˤΥ����।�٥�ȥϥ�ɥ�����ꤹ��
    #         �����ɤ��֤�
    #=================================================================
    def gc_pre_time_event_sta()
      return @cPreCondition.gc_pre_time_event_sta()  # [IMCodeElement]ư����֤Υ����।�٥�ȥϥ�ɥ�����ꤹ�륳����
    end

    #=================================================================
    # ��  ��: ���ľ��֤γ���ߤ����ꤹ�륳���ɤ��֤�
    #=================================================================
    def gc_pre_interrupt_ena()
      return @cPreCondition.gc_pre_interrupt_ena()  # [IMCodeElement]���ľ��֤γ���ߤ����ꤹ�륳����
    end

    #=================================================================
    # ��  ��: ����ͥ���٤Ƚ��ͥ���٤��ۤʤ륿���������������
    #         IMCodeElement���饹�ˤޤȤ���֤�(dormant�ʳ��Υ�����)
    #=================================================================
    def gc_pre_task_pri_chg()
      return @cPreCondition.gc_pre_task_pri_chg()  # [IMCodeElement]����ͥ���٤Ƚ��ͥ���٤��ۤʤ륿���������ꤹ�륳����
    end

    #=================================================================
    # ��  ��: �¹Ծ��֤Υ�����������򤹤륳���ɤ��֤�
    #=================================================================
    def gc_pre_task_running()
      return @cPreCondition.gc_pre_task_running()  # [IMCodeElement]�¹Ծ��֤Υ�����������򤹤륳����
    end

    #=================================================================
    # ��  ��: �ǥ����ѥå��ػߤˤ����륳���ɤ��֤�
    #=================================================================
    def gc_pre_dis_dsp()
      return @cPreCondition.gc_pre_dis_dsp()  # [IMCodeElement]�ǥ����ѥå��ػߤˤ����륳����
    end

    #=================================================================
    # ��  ��: �����ͥ���٥ޥ�����0�ʳ��ˤ����륳���ɤ��֤�
    #=================================================================
    def gc_pre_set_ipm()
      return @cPreCondition.gc_pre_set_ipm()  # [IMCodeElement]�����ͥ���٥ޥ�����0�ʳ��ˤ����륳����
    end

    #=================================================================
    # ��  ��: ��ư����󥿥��������ꥳ���ɤ��֤�
    #=================================================================
    def gc_pre_nontask_activate()
      return @cPreCondition.gc_pre_nontask_activate()  # [IMCodeElement]��ư����󥿥��������ꥳ����
    end

    #=================================================================
    # ��  ��: ���ֿʤ�륳���ɤ��֤�
    #=================================================================
    def gc_tick_gain(nIndex)
      check_class(Integer, nIndex)  # �����ܤ�do_post��

      cElement = IMCodeElement.new()

      @aDo_PostCondition[nIndex].gc_tick_gain(cElement)

      return cElement  # [IMCodeElement]���ֿʤ�륳����
    end

    #=================================================================
    # ��  ��: ������꡼�פ����Ƥ�������������¹Բ�ǽ���֤ˤ����륳���ɤ��֤�
    #=================================================================
    def gc_pre_task_ready_porder()
      return @cPreCondition.gc_pre_task_ready_porder()  # [IMCodeElement]������꡼�פ����Ƥ�������������¹Բ�ǽ���֤ˤ����륳����
    end

    #=================================================================
    # ��  ��: ��ư�������׵ᥭ�塼���󥰤�����򤹤륳���ɤ��֤�
    #=================================================================
    def gc_pre_task_queueing()
      return @cPreCondition.gc_pre_task_queueing()  # [IMCodeElement]��ư�������׵ᥭ�塼���󥰤�����򤹤륳����
    end

    #=================================================================
    # ��  ��: CPU��å����֤�����ʼ¹���ν���ñ�̤��������
    #=================================================================
    def gc_pre_cpu_loc()
      return @cPreCondition.gc_pre_cpu_loc()  # [IMCodeElement]CPU��å����֤�����򤹤륳����
    end

    #=================================================================
    # ��  ��: ����ǥ��������Υ��֥������Ȥ�ref�����ɤ��֤�
    #=================================================================
    def gc_obj_ref(nIndex = nil)
      check_class(Integer, nIndex, true)  # �����ܤ�do_post��

      if (nIndex.nil?())
        return @cPreCondition.gc_obj_ref()  # [IMCodeElement]����ǥ��������Υ��֥������Ȥ�ref������
      else
        return @aDo_PostCondition[nIndex].gc_obj_ref()  # [IMCodeElement]����ǥ��������Υ��֥������Ȥ�ref������
      end
    end

    #=================================================================
    # ��  ��: Do�ν����Υ����ɤ��֤�
    #=================================================================
    def gc_do(nIndex)
      check_class(Integer, nIndex)  # �����ܤ�do_post��

      if (nIndex == 0)
        cPrevObjectInfo = @cPreCondition.get_prev_actvate_running()
      else
        cPrevObjectInfo = @aDo_PostCondition[nIndex - 1].get_prev_actvate_running()
      end

      return @aDo_PostCondition[nIndex].gc_do(cPrevObjectInfo)  # [IMCodeElement]Do�ν����Υ�����
    end

    #=================================================================
    # ��  ��: CPU��å����֤β���Υ����ɤ��֤�
    #=================================================================
    def gc_lastpost_cpu_unl()
      return @aDo_PostCondition[TTG_IDX_LAST].gc_lastpost_cpu_unl()  # [IMCodeElement]CPU��å����֤β���Υ�����
    end

    #=================================================================
    # ��  ��: �Ǹ�θ���֤ǥᥤ�󥿥����򵯤��������ɤ��֤�
    #=================================================================
    def gc_lastpost_maintask_wup(nIndex)
      check_class(Integer, nIndex)  # �����ܤ�do_post��

      if (nIndex == 0)
        cPrevCondition = @cPreCondition
      else
        cPrevCondition = @aDo_PostCondition[TTG_IDX_LAST - 1]
      end

      return @aDo_PostCondition[TTG_IDX_LAST].gc_lastpost_maintask_wup(cPrevCondition.lMainTaskState)  # [IMCodeElement]�Ǹ�θ���֤ǥᥤ�󥿥����򵯤���������
    end

    #=================================================================
    # ��  ��: �ǥ����ѥå���ǽ�ˤ����륳���ɤ��֤�
    #=================================================================
    def gc_lastpost_ena_dsp()
      return @aDo_PostCondition[TTG_IDX_LAST].gc_lastpost_ena_dsp()  # [IMCodeElement]�ǥ����ѥå���ǽ�ˤ����륳����
    end

    #=================================================================
    # ��  ��: �����ͥ���٥ޥ��������������륳���ɤ��֤�
    #=================================================================
    def gc_lastpost_set_ini_ipm()
      return @aDo_PostCondition[TTG_IDX_LAST].gc_lastpost_set_ini_ipm()  # [IMCodeElement]�����ͥ���٥ޥ��������������륳����
    end

    #=================================================================
    # ��  ��: ư����֤Υ����।�٥�ȥϥ�ɥ����߽����Υ����ɤ��֤�
    #=================================================================
    def gc_lastpost_time_event_stp()
      return @aDo_PostCondition[TTG_IDX_LAST].gc_lastpost_time_event_stp()  # [IMCodeElement]ư����֤Υ����।�٥�ȥϥ�ɥ����߽����Υ�����
    end

    #=================================================================
    # ��  ��: �ػ߾��֤γ���ߤ����ꤹ�륳���ɤ��֤�
    #=================================================================
    def gc_lastpost_interrupt_dis()
      return @aDo_PostCondition[TTG_IDX_LAST].gc_lastpost_interrupt_dis()  # [IMCodeElement]�ػ߾��֤γ���ߤ����ꤹ�륳����
    end

    #=================================================================
    # ��  ��: ¾��������λ�����륳���ɤ��֤�
    #=================================================================
    def gc_lastpost_all_task_ter()
      return @aDo_PostCondition[TTG_IDX_LAST].gc_lastpost_all_task_ter()  # [IMCodeElement]¾��������λ�����륳����
    end

    #=================================================================
    # ��  ��: ��ư�׵ᥭ�塼���󥰤��������륳���ɤ��֤�
    #=================================================================
    def gc_lastpost_task_can_queueing()
      return @aDo_PostCondition[TTG_IDX_LAST].gc_lastpost_task_can_queueing()  # [IMCodeElement]��ư�׵ᥭ�塼���󥰤��������륳����
    end

    #=================================================================
    # ��  ��: ready�Υ�����������slp_tsk���륳���ɤ��֤�
    #=================================================================
    def gc_lastpost_ready_sleep()
      return @aDo_PostCondition[TTG_IDX_LAST].gc_lastpost_ready_sleep()  # [IMCodeElement]ready�Υ�����������slp_tsk���륳����
    end

    #=================================================================
    # ��  ��: �����֤ǡ����ξ��֤˹Ԥ����Υᥤ�󥿥��������ꤹ�륳����
    #         ���֤�
    #=================================================================
    def gc_pre_maintask_set()
      # [IMCodeElement]�����֤ǡ����ξ��֤˹Ԥ����Υᥤ�󥿥��������ꤹ�륳����
      return @cPreCondition.gc_pre_maintask_set(@aDo_PostCondition[0].cActivate, @aDo_PostCondition[0].cRunning, @aDo_PostCondition[0].check_cpu_loc(), @aDo_PostCondition[0].check_run_sus())
    end

    #=================================================================
    # ��  ��: ����֤ǡ����ξ��֤˹Ԥ����Υᥤ�󥿥��������ꤹ�륳����
    #         ���֤�
    #=================================================================
    def gc_post_maintask_set(nIndex, bGainTime)
      check_class(Integer, nIndex)  # �����ܤ�do_post��
      check_class(Bool, bGainTime)  # ���֤�ʤ�뤫

      if (nIndex == 0)
        cPrevCondition = @cPreCondition
      else
        cPrevCondition = @aDo_PostCondition[nIndex - 1]
      end
      cNowCondition  = @aDo_PostCondition[nIndex]
      cNextCondition = @aDo_PostCondition[nIndex + 1]

      # [IMCodeElement]����֤ǡ����ξ��֤˹Ԥ����Υᥤ�󥿥��������ꤹ�륳����
      return cNowCondition.gc_post_maintask_set(cNextCondition.cActivate, cNextCondition.cRunning, cNextCondition.check_cpu_loc(), cNextCondition.check_run_sus(), cPrevCondition.lMainTaskState, bGainTime)
    end

    #=================================================================
    # ��  ��: ��������å��ݥ���Ȥ���Ϥ��륳���ɤ��֤�
    #=================================================================
    def gc_checkpoint_zero()
      return @aDo_PostCondition[TTG_IDX_LAST].gc_checkpoint_zero()  # [IMCodeElement]��������å��ݥ���Ȥ���Ϥ��륳����
    end

    #=================================================================
    # ��  ��: @aDo_PostCondition��Index�������֤�
    #=================================================================
    def get_do_post_index()
      aIndex = []

      @aDo_PostCondition.each_index{|nIndex|
        aIndex.push(nIndex)
      }

      return aIndex  # [Array]Index����
    end

    #=================================================================
    # ��  ��: ������롼�����̵ͭ���֤�
    #=================================================================
    def exist_ini_rtn()
      return @cPreCondition.bIsIniRtn  # [Bool]������롼����¸�ߤ��뤫
    end

    #=================================================================
    # ��  ��: ��λ�롼�����̵ͭ���֤�
    #=================================================================
    def exist_ter_rtn()
      return @cPreCondition.bIsTerRtn  # [Bool]��λ�롼����¸�ߤ��뤫
    end

    #=================================================================
    # ��  ��: ����ߥϥ�ɥ��̵ͭ���֤�
    #=================================================================
    def exist_int_hdr()
      return @cPreCondition.bIsIntHdr  # [Bool]����ߥϥ�ɥ餬¸�ߤ��뤫
    end

    #=================================================================
    # ��  ��: ����ߥ����ӥ��롼�����̵ͭ���֤�
    #=================================================================
    def exist_isr()
      return @cPreCondition.bIsISR  # [Bool]����ߥ����ӥ��롼����¸�ߤ��뤫
    end

    #=================================================================
    # ��  ��: CPU�㳰�ϥ�ɥ��̵ͭ���֤�
    #=================================================================
    def exist_exception()
      return @cPreCondition.bIsException  # [Bool]CPU�㳰�ϥ�ɥ餬¸�ߤ��뤫
    end

    #=================================================================
    # ��  ��: ���ꤷ�����֥������Ȥ���������֤�
    #=================================================================
    def get_all_object_info(sObjectType)
      check_class(String, sObjectType)  # �оݤȤ��륪�֥������ȥ�����

      return @aDo_PostCondition[TTG_IDX_LAST].get_all_object_info(sObjectType)  # [Hash]���֥������Ⱦ���
    end

    #=================================================================
    # ��  ��: ���ꤷ�����֥������ȥ����פν���ñ�̤�ACTIVATE�Ǥ��륪��
    #         �������Ȥ�ID���֤�
    #=================================================================
    def get_activate_proc_unit_id(sObjectType)
      check_class(String, sObjectType)  # �оݤȤ��륪�֥������ȥ�����

      aProcUnitID = @cPreCondition.get_activate_proc_unit_id(sObjectType)

      @aDo_PostCondition.each{|cPostCondition|
        aProcUnitID.concat(cPostCondition.get_activate_proc_unit_id(sObjectType))
      }

      return aProcUnitID.uniq()  # [Array]ACTIVATE�Ǥ��륪�֥������Ȥ�ID
    end

    #=================================================================
    # ��  ��: TA_STA°���μ����ϥ�ɥ��̵ͭ���֤�
    #=================================================================
    def exist_cyclic_sta()
      return @cPreCondition.exist_cyclic_sta()  # [Bool]TA_STA°���μ����ϥ�ɥ餬¸�ߤ��뤫
    end

    #=================================================================
    # ��  ��: TA_ENAINT°���γ���ߥ����ӥ��롼�����̵ͭ���֤�
    #=================================================================
    def exist_isr_enaint()
      return @cPreCondition.exist_isr_enaint()  # [Bool]TA_ENAINT°���γ���ߥ����ӥ��롼����¸�ߤ��뤫
    end

    #=================================================================
    # ��  ��: �����/��λ�롼�����������򥪥֥�������ID�ǥ����Ȥ���
    #         ������֤�
    #=================================================================
    def get_ini_ter_object_info_sort_by_id(sObjectType)
      check_class(String, sObjectType)  # �оݤȤ��륪�֥������ȥ�����[�����or��λ�롼����]

      return @cPreCondition.get_ini_ter_object_info_sort_by_id(sObjectType)  # [Hash]���֥������Ⱦ���
    end

    #=================================================================
    # ��  ��: ���Υ���ǥ������ǵ�ư����ACTIVATE���󥿥�����¸�ߤ���
    #         ��硤��ư���Ԥĥ����ɤ��֤�
    #=================================================================
    def gc_wait_non_task_activate(nIndex)
      check_class(Integer, nIndex)  # �����ܤ�do_post��

      if (nIndex == 0)
        cPrevCondition = @cPreCondition
      else
        cPrevCondition = @aDo_PostCondition[nIndex - 1]
      end

      # [IMCodeElement]����֤ǡ����ξ��֤˹Ԥ����Υᥤ�󥿥��������ꤹ�륳����
      return @aDo_PostCondition[nIndex].gc_wait_non_task_activate(cPrevCondition.cActivate, @bGainTime)
    end
  end
end
