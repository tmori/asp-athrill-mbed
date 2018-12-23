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
#  $Id: IntermediateCode.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#
require "common/bin/CommonModule.rb"
require "common/bin/Config.rb"
require "common/bin/IMCodeElement.rb"

module TTG

  #==================================================================
  # ���饹̾: IntermediateCode
  # ����  ��: ��֥����ɤ��ݻ����륯�饹
  #==================================================================
  class IntermediateCode
    include CommonModule

    #================================================================
    # ������: ���󥹥ȥ饯��
    #================================================================
    def initialize()
      @aCode = []            # �����ɾ���
      @hProcUnitInfo = {}    # ����ñ�̤��Ȥ˻��ľ���ʥ������ѿ����ǽ���ư�����
      @aGlobalVar = []       # �����Х��ѿ����
      @aHeader = []          # �إå����ե�����˽��Ϥ������
      @hConfig = {}          # ����ե����ե�����˽��Ϥ������
      @nStack = 0            # �����å���ͭ����ɬ�פʥ����å���

      @cConf           = Config.new()                             # Config�����
      @nBlockSeqCnt    = 0                                        # �֥�å��Υ��������ֹ�
      @nBarrierSeqCnt  = 0                                        # BarrierSync�Υ��������ֹ�
      @aCheckSeqCnt    = Array.new(@cConf.get_prc_num() + 1, 0)   # �����å��ݥ���ȤΥ��������ֹ�ʥץ��å����Ȥ��ݻ���

      @nIndent             = 0 # ���ϥ����ɤ�����륿�֤θĿ�
      @bStateFunc          = false # state_sync�ؿ����ɲä���Ƥ��뤫
      @bWaitFinishFunc     = false # wait_finish_sync�ؿ����ɲä���Ƥ��뤫
      @bMigrateFunc        = false # migrate_task�ؿ����ɲä���Ƥ��뤫
      @bChgPriMainTaskFunc = false # chg_pri_main_task�ؿ����ɲä���Ƥ��뤫

      # ���ƥ��ȥ��ʥꥪ���̤ξ�����ɲä���
      add_common_info()

    end
    attr_reader :aCode, :hProcUnitInfo, :aGlobalVar, :aHeader, :hConfig, :nStack, :hMainTask, :hCheckMain


    #================================================================
    # ������: ���ƥ��ȥ��ʥꥪ���̤ξ�����ɲä���
    #================================================================
    def add_common_info()
      # ����Ū�ʥǡ�����¤������
      set_testid_level(IMC_COMMON)
      set_condition_level(IMC_TTG_MAIN)

      # �ᥤ�󥿥����Ⱦ��ֻ��ȥ����å��ؿ��ν���ñ�̾��������
      @hMainTask  = {:id => TTG_MAIN_TASK,  :prcid => @cConf.get_main_prcid(), :bootcnt => TTG_MAIN_BOOTCNT}
      @hCheckMain = {:id => FNC_CHECK_MAIN, :prcid => @cConf.get_main_prcid(), :bootcnt => TTG_MAIN_BOOTCNT}

      # �����ɾ��������ʬ�˳�Ǽ���륨����Ȥ��Ѱ�
      cElement = IMCodeElement.new(:common)

      # �ᥤ�󥿥����Ⱦ��ֻ��ȥ����å��ؿ����ɲ�
      cElement.set_proc_unit(@hMainTask[:id], @hMainTask[:bootcnt])
      cElement.set_proc_unit(@hCheckMain[:id], @hCheckMain[:bootcnt])

      # �ץ�ȥ�����������ɲ�
      cElement.set_header(@hMainTask[:id], TSR_OBJ_TASK)
      cElement.set_header(@hCheckMain[:id], IMC_FUNC_TYPE)

      # ��ŪAPI������ɲ�
      cElement.set_config("#{API_CRE_TSK}(#{TTG_MAIN_TASK}, {#{KER_TA_ACT}, 1, #{TTG_MAIN_TASK.downcase}, #{TTG_MAIN_PRI}, TTSP_TASK_STACK_SIZE, NULL});", @cConf.get_default_class())

      # �������ѿ����ɲ�
      cElement.set_local_var(@hCheckMain[:id], GRP_VAR_TYPE[TYP_T_TTSP_RTSK], TYP_T_TTSP_RTSK)

      # ��Χ�ǻ��֤�Ȥ����ϡ��ǽ�˻������
      if (!@cConf.is_all_gain_time_mode?())
        cElement.set_code(@hMainTask, "#{FNC_STOP_TICK}()")
      end
      cElement.set_syscall(@hCheckMain, "#{FNC_REF_TSK}(#{TTG_MAIN_TASK}, &#{GRP_VAR_TYPE[TYP_T_TTSP_RTSK]})")
      cElement.set_assert(@hCheckMain, "#{GRP_VAR_TYPE[TYP_T_TTSP_RTSK]}.#{STR_TSKSTAT}", KER_TTS_RUN)
      cElement.set_assert(@hCheckMain, "#{GRP_VAR_TYPE[TYP_T_TTSP_RTSK]}.#{STR_TSKPRI}",  TTG_MAIN_PRI)
      cElement.set_assert(@hCheckMain, "#{GRP_VAR_TYPE[TYP_T_TTSP_RTSK]}.#{STR_ITSKPRI}", TTG_MAIN_PRI)
      cElement.set_assert(@hCheckMain, "#{GRP_VAR_TYPE[TYP_T_TTSP_RTSK]}.#{STR_ACTCNT}",  0)
      cElement.set_assert(@hCheckMain, "#{GRP_VAR_TYPE[TYP_T_TTSP_RTSK]}.#{STR_WUPCNT}",  0)

      # FMP�ξ��Τ��ɲä������
      if (@cConf.is_fmp?())
        cElement.set_assert(@hCheckMain, "#{GRP_VAR_TYPE[TYP_T_TTSP_RTSK]}.#{STR_PRCID}", @cConf.get_main_prcid())
      end

      # ������Ȥ��ɲä���
      add_element(cElement)
    end


    #================================================================
    # ������: IMCodeElement����֥����ɤ��Ѵ������ݻ�����
    #================================================================
    def add_element(cElement)
      check_class(IMCodeElement, cElement, true) # IMCodeElement���饹�Υ��󥹥���

      if (cElement.nil?())
        return
      end

      aCode      = []    # �������������ɾ������Ū���ݻ�
      aCodeBlock = []    # �֥�å�ñ�̤ǥ����ɾ�����ݻ�
      bPassed    = false # �ХꥢƱ���Υ��������ֹ�����ե饰

      cElement.aElement.each{|hElement|
        # °���ˤ�äưۤʤ���ˡ����֥����ɤ��������Ƴ�Ǽ����
        # �����ɾ���ϳ�Ǽ������ʣ���ʤΤ������Τ߹Ԥ�
        case hElement[:atr]
        when :api
          sCode = "#{hElement[:var]} = #{hElement[:syscall]};"
        when :ercd
          sCode = "#{FNC_CHECK_ERCD}(#{hElement[:var]}, #{hElement[:ret]});"
        when :assert
          sCode = "#{FNC_CHECK_ASSERT}(#{hElement[:var]} == #{hElement[:value]});"
        when :check
          sMainPrcid = @cConf.get_main_prcid()
          @aCheckSeqCnt[sMainPrcid] += 1
          sCode = "#{FNC_CHECK_POINT}(#{@aCheckSeqCnt[sMainPrcid]});"
        when :wait
          sMainPrcid = @cConf.get_main_prcid()
          sCode = "#{FNC_WAIT_CHECK_POINT}(#{@aCheckSeqCnt[sMainPrcid]});"
        when :check_mp
          @aCheckSeqCnt[hElement[:proc_unit][:prcid]] += 1
          sCode = "#{FNC_MP_CHECK_POINT}(#{hElement[:proc_unit][:prcid]}, #{@aCheckSeqCnt[hElement[:proc_unit][:prcid]]});"
        when :check_zero
          sCode = "#{FNC_CHECK_POINT}(0);"
        when :check_finish
          sMainPrcid = @cConf.get_main_prcid()
          @aCheckSeqCnt[sMainPrcid] += 1
          sCode = "#{FNC_CHECK_FINISH}(#{@aCheckSeqCnt[sMainPrcid]});"
        when :check_finish_mp
          @aCheckSeqCnt[hElement[:proc_unit][:prcid]] += 1
          sCode = "#{FNC_MP_CHECK_FINISH}(#{hElement[:proc_unit][:prcid]}, #{@aCheckSeqCnt[hElement[:proc_unit][:prcid]]});"
        when :waitcp
          sCode = "#{FNC_MP_WAIT_CHECK_POINT}(#{hElement[:prcid]}, #{@aCheckSeqCnt[hElement[:prcid]]});"
        when :barrier
          # ��ĤΥ�����Ȥǰ��������󥯥����
          if (bPassed != true)
            @nBarrierSeqCnt += 1
            bPassed = true
          end
          sCode = "#{FNC_BARRIER_SYNC}(#{@nBarrierSeqCnt}, #{hElement[:num]});"
        when :comment
          sCode = "/* #{hElement[:code]} */"
        when :expression, :statement
          sCode = "#{hElement[:code]}"
        when :localvar
          add_local_var(hElement)
          next
        when :globalvar
          add_global_var(hElement)
          next
        when :header
          add_header(hElement)
          next
        when :config
          add_config(hElement)
          next
        when :proc_unit
          add_proc_unit(hElement)
          next
        when :delimiter_cmd
          # �֥�å���ʬ����
          aCodeBlock.push(aCode)
          aCode = []
          next
        when :indent_cmd
          @nIndent = hElement[:num]
          next
        when :unindent_cmd
          @nIndent = 0
          next
        when :migrate_func
          add_migrate_task()
          next
        when :chg_pri_main_task
          add_chg_pri_main_task()
          next
        when :precode
          add_pre_code(hElement)
          next
        when :postcode
          add_post_code(hElement)
          next
        else
          abort(ERR_MSG % [__FILE__, __LINE__])
        end

        # ����ǥ��̿�᤬����ˤʤäƤ����硤����ǥ�Ȥ�Ԥ�
        sCode = TTG_TB * @nIndent + sCode

        # �����ɾ�����������ư��Ū���ݻ�����
        aCode.push([hElement[:proc_unit][:id], sCode, hElement[:proc_unit][:bootcnt], hElement[:proc_unit][:prcid], hElement[:atr]])
      }

      # �֥�å�����������
      aCodeBlock.push(aCode)

      # ���Υ֥�å��������
      aCodeBlock.delete_if{ |aBlock|
        aBlock.empty?()
      }
      # ��Ĥ�Ĥ�ʤ���Х꥿����
      if (aCodeBlock.empty?())
        return
      end

      if (cElement.lMode == :block)
        sTestID = get_current_level()
        sCondition = get_current_level(sTestID)

        aCodeBlock.each{ |aBlock|
          @nBlockSeqCnt += 1
          @aCode[TTG_IDX_LAST][sTestID][TTG_IDX_LAST][sCondition].push({IMC_BLOCK + "_#{@nBlockSeqCnt}" => aBlock})
        }
      else
        # common�⡼�ɤξ��϶�����ʬ�˥����ɾ�����Ǽ����
        @aCode[0][IMC_COMMON][0][IMC_TTG_MAIN].concat(aCodeBlock[0])
      end
    end


    #================================================================
    # ������: aCode�˥ƥ���ID��٥���ɲä���
    #================================================================
    def set_testid_level(sTestID)
      check_class(String, sTestID) # �ƥ���ID

      # �ƥ���ID��٥���ɲä���
      @aCode.push({sTestID => []})
    end


    #================================================================
    # ������: aCode�˥���ǥ�������٥���ɲä���
    #================================================================
    def set_condition_level(sCondition)
      check_class(String, sCondition) # Condition or do

      # ���ߤΥƥ���ID��٥�Υ������������
      sTestID = get_current_level()
      #����ǥ�������٥���ɲä���
      @aCode[TTG_IDX_LAST][sTestID].push({sCondition => []})

    end


    #================================================================
    # ������: aCode�λ��ꤷ����٥�Υ���̾���������
    #================================================================
    def get_current_level(sTestID = nil)
      check_class(String, sTestID, true)    # ���ߤΥƥ���ID��٥�

      if (sTestID.nil?())
        # ���ߤΥƥ���ID��٥�Υ���̾���֤�
        return @aCode[TTG_IDX_LAST].keys[0] # [String]��٥�Υ���̾
      else
        # ���ߤΥ���ǥ�������٥�Υ���̾���֤�
        return @aCode[TTG_IDX_LAST][sTestID][TTG_IDX_LAST].keys[0] # [String]��٥�Υ���̾
      end
    end
    private :get_current_level


    #================================================================
    # ������: ����ñ�̾�����ɲä�Ԥ�
    #================================================================
    def add_proc_unit(hElement)
      check_class(Hash, hElement) # ����ñ�̾��������

      @hProcUnitInfo[hElement[:proc_unit_id]] = {:localvar => {}, :fbootcnt => hElement[:fbootcnt], :precode => [], :postcode => []}
    end
    private :add_proc_unit


    #================================================================
    # ������: �������ѿ���������ɽ���Υǡ�����¤���Ѵ������ݻ�����
    #================================================================
    def add_local_var(hElement)
      check_class(Hash, hElement) # �������ѿ����������

      # ����ñ�̤���Ͽ����Ƥ��ʤ���Х��顼
      unless (@hProcUnitInfo.has_key?(hElement[:proc_unit_id]))
        abort(ERR_MSG % [__FILE__, __LINE__])
      end

      @hProcUnitInfo[hElement[:proc_unit_id]][:localvar].update({hElement[:name] => {:type => hElement[:type], :value => hElement[:value]}})
    end
    private :add_local_var


    #================================================================
    # ������: �����Х��ѿ���������ɽ���Υǡ�����¤���Ѵ������ݻ���
    #         ��
    #================================================================
    def add_global_var(hElement)
      check_class(Hash, hElement) # �����Х��ѿ����������

      @aGlobalVar.push([hElement[:name], hElement[:type], hElement[:value]])
      @aGlobalVar.uniq!()
    end
    private :add_global_var


    #================================================================
    # ������: ����ñ�̤Υץ�ȥ�������������ɽ���Υǡ�����¤���Ѵ���
    #         ���ݻ�����
    #================================================================
    def add_header(hElement)
      check_class(Hash, hElement) # �ץ�ȥ�����������������

      sFuncID = hElement[:proc_unit_id].downcase

      case hElement[:type]
      when TSR_OBJ_TASK, TSR_OBJ_ALARM, TSR_OBJ_CYCLE, TSR_OBJ_ISR, TSR_OBJ_INIRTN, TSR_OBJ_TERRTN
        aArgs = ["#{TYP_INTPTR_T} #{VAR_EXINF}"]
      when TSR_OBJ_TASK_EXC
        aArgs = ["#{TYP_TEXPTN} #{VAR_TEXPTN}", "#{TYP_INTPTR_T} #{VAR_EXINF}"]
      when TSR_OBJ_INTHDR
        aArgs = [TYP_VOID]
      when TSR_OBJ_EXCEPTION
        aArgs = ["#{TYP_VOID_P} #{@cConf.get_exception_arg_name()}"]
      when IMC_FUNC_TYPE # TEST_MAIN��CHECK_MAIN��Ʊ���ؿ�
        aArgs = hElement[:args] || []
      else
        # ����̵�����顼
        abort(ERR_MSG % [__FILE__, __LINE__])
      end

      @aHeader.push([sFuncID, aArgs])
    end
    private :add_header


    #================================================================
    # ������: ��ŪAPI�ξ�������ɽ���Υǡ�����¤���Ѵ������ݻ�����
    #================================================================
    def add_config(hElement)
      check_class(Hash, hElement) # ��ŪAPI���������

      if (@cConf.is_asp?())
        sClass = IMC_NO_CLASS
      else
        sClass = hElement[:class]
      end

      if (@hConfig[sClass].nil?())
        @hConfig[sClass] = []
      end

      @hConfig[sClass].push(hElement[:code])
      @hConfig[sClass].uniq!()
    end
    private :add_config


    #================================================================
    # ������: ��ͭ���륹���å���ɬ�׺�����򹹿�����
    #================================================================
    def update_stack_size(nStack)
      check_class(Integer, nStack) # ɬ�פʥ����å���

      if (@nStack < nStack)
        @nStack = nStack
      end
    end


    #================================================================
    # ������: migrate_task�ؿ������Υ����ɤ򥨥���Ȥ��ɲä���
    #================================================================
    def add_migrate_task()
      # ������֥����ɲ�����Ƥ������ϲ��⤷�ʤ�
      if (@bMigrateFunc == true)
        return
      end
      @bMigrateFunc = true

      # �����ɾ��������ʬ�˳�Ǽ���륨����Ȥ��Ѱ�
      cElement = IMCodeElement.new(:common)

      # ����ñ�̤ǤϤʤ�����ץ��å�ID��bootcnt�ϥ��ߡ�
      nMainPrcid = @cConf.get_main_prcid()
      hFuncInfo = {:id => FNC_MIGRATE_TASK, :prcid => nMainPrcid, :bootcnt => TTG_MAIN_BOOTCNT}

      cElement.set_proc_unit(hFuncInfo[:id], hFuncInfo[:bootcnt])
      cElement.set_header(hFuncInfo[:id], IMC_FUNC_TYPE, ["#{TYP_ID} #{VAR_TARGET_TSKID}, #{TYP_ID} #{VAR_PRCID}"])

      # ���ߤγ��եץ��å������ꤷ���ץ��å��Ǥʤ����Ȥ�Ƚ�̤��륳���ɤ���������
      cElement.set_local_var(hFuncInfo[:id], GRP_VAR_TYPE[TYP_T_TTSP_RTSK], TYP_T_TTSP_RTSK)
      cElement.set_syscall(hFuncInfo, "#{FNC_REF_TSK}(#{VAR_TARGET_TSKID}, &#{GRP_VAR_TYPE[TYP_T_TTSP_RTSK]})")
      cElement.set_code(hFuncInfo, "if (#{GRP_VAR_TYPE[TYP_T_TTSP_RTSK]}.#{STR_PRCID} != #{VAR_PRCID}) {", false)
      cElement.set_indent(1)

      # ����˸��ߤγ��եץ��å����ᥤ��ץ��å��Ȱۤʤ���ϡ��ᥤ�󥿥�����mig_tsk����
      cElement.set_code(hFuncInfo, "if (#{GRP_VAR_TYPE[TYP_T_TTSP_RTSK]}.#{STR_PRCID} != #{nMainPrcid}) {", false)
      cElement.set_indent(2)
      cElement.set_syscall(hFuncInfo, "#{API_MIG_TSK}(#{TTG_TSK_SELF}, #{GRP_VAR_TYPE[TYP_T_TTSP_RTSK]}.#{STR_PRCID})")
      cElement.set_indent(1)
      cElement.set_code(hFuncInfo, "}", false)

      cElement.set_syscall(hFuncInfo, "#{API_MIG_TSK}(#{VAR_TARGET_TSKID}, #{VAR_PRCID})")

      cElement.set_code(hFuncInfo, "if (#{GRP_VAR_TYPE[TYP_T_TTSP_RTSK]}.#{STR_PRCID} != #{nMainPrcid}) {", false)
      cElement.set_indent(2)
      cElement.set_syscall(hFuncInfo, "#{API_MIG_TSK}(#{TTG_TSK_SELF}, #{nMainPrcid})")
      cElement.set_indent(1)
      cElement.set_code(hFuncInfo, "}", false)

      cElement.unset_indent()
      cElement.set_code(hFuncInfo, "}", false)

      # ������Ȥ��ɲä���
      add_element(cElement)
    end
    private :add_migrate_task

    #================================================================
    # ������: chg_pri_main_task�ؿ������Υ����ɤ򥨥���Ȥ��ɲä���
    #================================================================
    def add_chg_pri_main_task()
      # ������֥����ɲ�����Ƥ������ϲ��⤷�ʤ�
      if (@bChgPriMainTaskFunc == true)
        return
      end
      @bChgPriMainTaskFunc = true

      # �����ɾ��������ʬ�˳�Ǽ���륨����Ȥ��Ѱ�
      cElement = IMCodeElement.new(:common)

      # ����ñ�̤ǤϤʤ�����ץ��å�ID��bootcnt�ϥ��ߡ�
      nMainPrcid = @cConf.get_main_prcid()
      hFuncInfo = {:id => FNC_CHG_PRI_MAIN_TASK, :prcid => nMainPrcid, :bootcnt => TTG_MAIN_BOOTCNT}

      cElement.set_proc_unit(hFuncInfo[:id], hFuncInfo[:bootcnt])
      cElement.set_header(hFuncInfo[:id], IMC_FUNC_TYPE)

      # �ᥤ�󥿥����ξ��֤򻲾Ȥ��륳���ɤ���������
      cElement.set_local_var(hFuncInfo[:id], GRP_VAR_TYPE[TYP_T_TTSP_RTSK], TYP_T_TTSP_RTSK)
      cElement.set_syscall(hFuncInfo, "#{FNC_REF_TSK}(#{TTG_MAIN_TASK}, &#{GRP_VAR_TYPE[TYP_T_TTSP_RTSK]})")

      # �ᥤ�󥿥�����ͥ���٤�1�Ǥʤ����ϡ�1���ѹ�����
      cElement.set_code(hFuncInfo, "if (#{GRP_VAR_TYPE[TYP_T_TTSP_RTSK]}.#{STR_TSKPRI} != #{TTG_MAIN_PRI}) {", false)
      cElement.set_indent(1)
      cElement.set_syscall(hFuncInfo, "#{API_CHG_PRI}(#{TTG_MAIN_TASK}, #{TTG_MAIN_PRI})")
      cElement.unset_indent()
      cElement.set_code(hFuncInfo, "}", false)

      # ������Ȥ��ɲä���
      add_element(cElement)
    end
    private :add_chg_pri_main_task

    #================================================================
    # ������: ASP��gcov_resume�ؿ������Υ����ɤ򥨥���Ȥ��ɲä���
    #         (FMP�ȴؿ�̾���碌�뤿��Υ�åѡ�)
    #================================================================
    def add_gcov_resume_asp()
      cElement = IMCodeElement.new(:common)
      nMainPrcid = @cConf.get_main_prcid()
      hFuncInfo = {:id => FNC_GCOV_TTG_RESUME, :prcid => nMainPrcid, :bootcnt => TTG_MAIN_BOOTCNT}
      cElement.set_proc_unit(hFuncInfo[:id], hFuncInfo[:bootcnt])
      cElement.set_header(hFuncInfo[:id], IMC_FUNC_TYPE)
      cElement.set_code(hFuncInfo, FNC_GCOV_C_RESUME)
      add_element(cElement)
    end

    #================================================================
    # ������: ASP��gcov_pause�ؿ������Υ����ɤ򥨥���Ȥ��ɲä���
    #================================================================
    def add_gcov_pause_asp()
      cElement = IMCodeElement.new(:common)
      nMainPrcid = @cConf.get_main_prcid()
      hFuncInfo = {:id => FNC_GCOV_TTG_PAUSE, :prcid => nMainPrcid, :bootcnt => TTG_MAIN_BOOTCNT}
      cElement.set_proc_unit(hFuncInfo[:id], hFuncInfo[:bootcnt])
      cElement.set_header(hFuncInfo[:id], IMC_FUNC_TYPE)
      cElement.set_code(hFuncInfo, FNC_GCOV_C_PAUSE)
      add_element(cElement)
    end

    #================================================================
    # ������: FMP��gcov_resume�ؿ������Υ����ɤ򥨥���Ȥ��ɲä���
    #================================================================
    def add_gcov_resume_fmp()
      # �����ɾ��������ʬ�˳�Ǽ���륨����Ȥ��Ѱ�
      cElement = IMCodeElement.new(:common)

      # ����ñ�̤ǤϤʤ�����ץ��å�ID��bootcnt�ϥ��ߡ�
      nMainPrcid = @cConf.get_main_prcid()
      hFuncInfo = {:id => FNC_GCOV_TTG_RESUME, :prcid => nMainPrcid, :bootcnt => TTG_MAIN_BOOTCNT}

      cElement.set_proc_unit(hFuncInfo[:id], hFuncInfo[:bootcnt])
      cElement.set_header(hFuncInfo[:id], IMC_FUNC_TYPE)

      # �����Х��ѿ����
      cElement.set_global_var(VAR_GCOV_LOCK_FLG, TYP_BOOL_T, false)

      # �������ѿ����
      cElement.set_local_var(hFuncInfo[:id], VAR_TIMEOUT, TYP_ULONG_T, 0)

      cElement.set_code(hFuncInfo, SIL_PRE_LOC)

      cElement.set_code(hFuncInfo, "while (1) {", false)
      cElement.set_indent(1)

      cElement.set_code(hFuncInfo, SIL_LOC_SPN)
      cElement.set_code(hFuncInfo, "if (#{VAR_GCOV_LOCK_FLG} == false) {", false)
      cElement.set_indent(2)
      cElement.set_code(hFuncInfo, "#{VAR_GCOV_LOCK_FLG} = true")
      cElement.set_code(hFuncInfo, SIL_UNL_SPN)
      cElement.set_code(hFuncInfo, FNC_GCOV_C_RESUME)
      cElement.set_code(hFuncInfo, "return")
      cElement.set_indent(1)
      cElement.set_code(hFuncInfo, "}", false)
      cElement.set_code(hFuncInfo, SIL_UNL_SPN)

      cElement.set_code(hFuncInfo, "#{VAR_TIMEOUT}++")

      cElement.set_code(hFuncInfo, "if (#{VAR_TIMEOUT} > #{TTG_LOOP_COUNT}) {", false)
      cElement.set_indent(2)
      cElement.set_code(hFuncInfo, "syslog_0(LOG_ERROR, \"## #{FNC_GCOV_TTG_C_RESUME} caused a timeout.\")")
      cElement.set_code(hFuncInfo, "if (#{API_SNS_KER}() == false) {", false)
      cElement.set_indent(3)
      cElement.set_code(hFuncInfo, "#{API_EXT_KER}()")
      cElement.set_indent(2)
      cElement.set_code(hFuncInfo, "}", false)
      cElement.set_code(hFuncInfo, "else {", false)
      cElement.set_indent(3)
      cElement.set_code(hFuncInfo, "return")
      cElement.set_indent(2)
      cElement.set_code(hFuncInfo, "}", false)
      cElement.set_indent(1)
      cElement.set_code(hFuncInfo, "}", false)

      cElement.set_code(hFuncInfo, "sil_dly_nse(#{TTG_SIL_DLY_NSE_TIME})")

      cElement.unset_indent()
      cElement.set_code(hFuncInfo, "}", false)

      # ������Ȥ��ɲä���
      add_element(cElement)
    end

    #================================================================
    # ������: FMP��gcov_pause�ؿ������Υ����ɤ򥨥���Ȥ��ɲä���
    #================================================================
    def add_gcov_pause_fmp()
      # �����ɾ��������ʬ�˳�Ǽ���륨����Ȥ��Ѱ�
      cElement = IMCodeElement.new(:common)

      # ����ñ�̤ǤϤʤ�����ץ��å�ID��bootcnt�ϥ��ߡ�
      nMainPrcid = @cConf.get_main_prcid()
      hFuncInfo = {:id => FNC_GCOV_TTG_PAUSE, :prcid => nMainPrcid, :bootcnt => TTG_MAIN_BOOTCNT}

      cElement.set_proc_unit(hFuncInfo[:id], hFuncInfo[:bootcnt])
      cElement.set_header(hFuncInfo[:id], IMC_FUNC_TYPE)

      cElement.set_code(hFuncInfo, "if (#{VAR_GCOV_LOCK_FLG} == false) {", false)
      cElement.set_indent(1)
      cElement.set_code(hFuncInfo, "syslog_0(LOG_ERROR, \"## #{VAR_GCOV_LOCK_FLG} don't be true. [#{FNC_GCOV_TTG_PAUSE}]\")")
      cElement.set_code(hFuncInfo, "if (#{API_SNS_KER}() == false) {", false)
      cElement.set_indent(2)
      cElement.set_code(hFuncInfo, "#{API_EXT_KER}()")
      cElement.set_indent(1)
      cElement.set_code(hFuncInfo, "}", false)
      cElement.set_code(hFuncInfo, "else {", false)
      cElement.set_indent(2)
      cElement.set_code(hFuncInfo, "return")
      cElement.set_indent(1)
      cElement.set_code(hFuncInfo, "}", false)
      cElement.unset_indent()
      cElement.set_code(hFuncInfo, "}", false)

      cElement.set_code(hFuncInfo, FNC_GCOV_C_PAUSE)

      cElement.set_code(hFuncInfo, "#{VAR_GCOV_LOCK_FLG} = false")

      # ������Ȥ��ɲä���
      add_element(cElement)
    end


    #================================================================
    # ������: �ץ쥳���ɾ�������ɽ���Υǡ�����¤���Ѵ������ݻ�����
    #================================================================
    def add_pre_code(hElement)
      check_class(Hash, hElement) # �ץ쥳���ɾ��������

      # ����ñ�̤���Ͽ����Ƥ��ʤ���Х��顼
      unless (@hProcUnitInfo.has_key?(hElement[:proc_unit]))
        abort(ERR_MSG % [__FILE__, __LINE__])
      end

      @hProcUnitInfo[hElement[:proc_unit]][:precode].push(hElement[:code])
    end
    private :add_pre_code


    #================================================================
    # ������: �ݥ��ȥ����ɾ�������ɽ���Υǡ�����¤���Ѵ������ݻ�����
    #================================================================
    def add_post_code(hElement)
      check_class(Hash, hElement) # �ݥ��ȥ����ɾ��������

      # ����ñ�̤���Ͽ����Ƥ��ʤ���Х��顼
      unless (@hProcUnitInfo.has_key?(hElement[:proc_unit]))
        abort(ERR_MSG % [__FILE__, __LINE__])
      end

      @hProcUnitInfo[hElement[:proc_unit]][:postcode].push(hElement[:code])
    end
    private :add_post_code


    #================================================================
    # ������: ASP�ѻ�������ؿ������Υ����ɤ򥨥���Ȥ��ɲä���
    #================================================================
    def add_gain_tick_asp()
      # �����ɾ��������ʬ�˳�Ǽ���륨����Ȥ��Ѱ�
      cElement = IMCodeElement.new(:common)

      # ����ñ�̤ǤϤʤ�����ץ��å�ID��bootcnt�ϥ��ߡ�
      nMainPrcid = @cConf.get_main_prcid()
      hFuncInfo = {:id => FNC_TARGET_GAIN_TICK, :prcid => nMainPrcid, :bootcnt => TTG_MAIN_BOOTCNT}

      cElement.set_proc_unit(hFuncInfo[:id], hFuncInfo[:bootcnt])
      cElement.set_header(hFuncInfo[:id], IMC_FUNC_TYPE)

      # �������ѿ����
      cElement.set_local_var(hFuncInfo[:id], VAR_ERCD, TYP_ER)
      cElement.set_local_var(hFuncInfo[:id], VAR_SYSTIM1, TYP_SYSTIM)
      cElement.set_local_var(hFuncInfo[:id], VAR_SYSTIM2, TYP_SYSTIM)
      cElement.set_local_var(hFuncInfo[:id], VAR_TIMEOUT, TYP_ULONG_T, 0)

      # �������åȰ�¸�λ�������ؿ��ˤ�äƥ����ƥ���郎�ʤ�����Ȥ��ǧ����
      cElement.set_syscall(hFuncInfo, "#{API_GET_TIM}(&#{VAR_SYSTIM1})")
      cElement.set_code(hFuncInfo, "#{FNC_GAIN_TICK}()")
      cElement.set_code(hFuncInfo, "while (1) {", false)
      cElement.set_indent(1)

      cElement.set_syscall(hFuncInfo, "#{API_GET_TIM}(&#{VAR_SYSTIM2})")
      cElement.set_code(hFuncInfo, "if (#{VAR_SYSTIM1} != #{VAR_SYSTIM2}) {", false)
      cElement.set_indent(2)
      cElement.set_code(hFuncInfo, "return")
      cElement.set_indent(1)
      cElement.set_code(hFuncInfo, "}", false)

      cElement.set_code(hFuncInfo, "#{VAR_TIMEOUT}++")

      cElement.set_code(hFuncInfo, "if (#{VAR_TIMEOUT} > #{TTG_LOOP_COUNT}) {", false)
      cElement.set_indent(2)
      cElement.set_code(hFuncInfo, "syslog_0(LOG_ERROR, \"## #{FNC_TARGET_GAIN_TICK}() caused a timeout.\")")
      cElement.set_code(hFuncInfo, "#{API_EXT_KER}()")
      cElement.set_indent(1)
      cElement.set_code(hFuncInfo, "}", false)

      cElement.set_code(hFuncInfo, "sil_dly_nse(#{TTG_SIL_DLY_NSE_TIME})")

      cElement.unset_indent()
      cElement.set_code(hFuncInfo, "}", false)

      # ������Ȥ��ɲä���
      add_element(cElement)
    end


    #================================================================
    # ������: IntermediateCode��pp��긫�䤹�������������ƽ��Ϥ���
    #================================================================
    def p_code(lOption = nil)
      check_class(Symbol, lOption, true) # ���ꥪ�ץ����

      # �����ɾ���ν���
      puts "--- added CodeInfo ---"
      @aCode.each{ |hScenarios|
        hScenarios.each{ |sTestID, aTestIDLevel|
          puts "#{sTestID} => "
          aTestIDLevel.each{ |hScenario|
            hScenario.each{ |sCondition, aConditionLevel|
              puts "  #{sCondition} => "
              if (sCondition == IMC_TTG_MAIN)
                aConditionLevel.each{ |aCodeInfo|
                  print "      "
                  p aCodeInfo
                }
              else
                aConditionLevel.each{ |hBlocks|
                  hBlocks.each{ |sBlock, aBlockLevel|
                    puts "    #{sBlock} => "
                    aBlockLevel.each{ |aCodeInfo|
                      print "      "
                      p aCodeInfo
                    }
                  }
                }
              end
            }
          }
        }
      }

      if (lOption == :all)
        require "pp"
        puts ""
        print "@hProcUnitInfo = ".ljust(17); pp @hProcUnitInfo
        print "@aGlobalVar = ".ljust(17);    pp @aGlobalVar
        print "@aHeader = ".ljust(17);       pp @aHeader
        print "@hConfig = ".ljust(17);       pp @hConfig
        print "@nStack = ".ljust(17);        pp @nStack
      end
    end

  end
end
