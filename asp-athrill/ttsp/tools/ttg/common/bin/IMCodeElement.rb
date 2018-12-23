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
#  $Id: IMCodeElement.rb 6 2012-09-03 11:06:01Z nces-shigihara $
#
require "common/bin/CommonModule.rb"
require "common/bin/Config.rb"

module CommonModule

  #==================================================================
  # ���饹̾: IMCodeElement
  # ����  ��: IntermediateCode�����Ǥ����������֥����ɤ����Ǥ��Ǽ
  #           ���륯�饹
  #==================================================================
  class IMCodeElement
    include CommonModule

    #================================================================
    # ������: ���󥹥ȥ饯����
    #         ���ꤷ�������פΥ�����Ȥ���������
    #================================================================
    def initialize(lMode = :block)
      check_class(Symbol, lMode) # �������������ɤ�Block�����뤫���������������뤫�ʥǥե���� :block��

      @aElement = []           # ���Ǥ��ݻ�
      @cConf    = Config.new() # ����ե��������

      # �⡼�ɤ�����
      if (lMode == :block || :common)
        @lMode = lMode
      else
        abort(ERR_MSG % [__FILE__, __LINE__])
      end

    end
    attr_reader :aElement, :lMode


    #================================================================
    # ������: API�ƤӽФ�������ͤΥ����å���Ԥ������ɤ����Ǥ��ݻ�����
    #================================================================
    def set_syscall(hProcUnitInfo, sSyscall, snbReturn = "E_OK", sVarType = TYP_ER)
      check_class(Hash, hProcUnitInfo)                       # �����ɤ��ɲä������ñ�̾���
      check_class(String, sSyscall)                          # �ɲä���API
      check_class([String, Integer, *Bool], snbReturn, true) # ���ꤵ�������͡ʥǥե���� E_OK��
      check_class(String, sVarType)                          # ���ꤵ�������ͤη��ʥǥե���� TYP_ER��

      # �ѿ�̾�����
      sVarName = GRP_VAR_TYPE[sVarType]

      # ����ͤΥ����å���Ԥ����
      if (!snbReturn.nil?())
        @aElement.push({:atr => :api, :proc_unit => hProcUnitInfo, :syscall => sSyscall, :var => sVarName})
        set_local_var(hProcUnitInfo[:id], sVarName, sVarType)

        # ����ͤη���TYP_ER��TYP_ER_UINT�ξ���check_ercd
        if (sVarType != TYP_BOOL_T)
          @aElement.push({:atr => :ercd, :proc_unit => hProcUnitInfo, :ret => snbReturn, :var => sVarName})
        # ����ͤη���TYP_BOOL_T�ξ���assert
        else
          set_assert(hProcUnitInfo, sVarName, snbReturn)
        end

      # ����ͤΥ����å���Ԥ�ʤ����
      else
        # �ƤӽФ�¦�Ǹ��̤˥����å����Ƥ���Ȥ������뤿��
        set_local_var(hProcUnitInfo[:id], sVarName, sVarType)
        @aElement.push({:atr => :api, :proc_unit => hProcUnitInfo, :syscall => sSyscall, :var => sVarName})
      end
    end


    #================================================================
    # ������: assert�����å���Ԥ������ɤ����Ǥ��ݻ�����
    #================================================================
    def set_assert(hProcUnitInfo, sVar, snbValue)
      check_class(Hash, hProcUnitInfo)                # �����ɤ��ɲä������ñ�̾���
      check_class(String, sVar)                       # assert�ˤ�äƳ�ǧ�����ѿ�
      check_class([String, Integer, *Bool], snbValue) # assert�ˤ�äƳ�ǧ������

      @aElement.push({:atr => :assert, :proc_unit => hProcUnitInfo, :var => sVar, :value => snbValue})
    end


    #================================================================
    # ������: ������Ϳ����ʸ����򤽤Τޤ޽��Ϥ������Ǥ��ݻ����롥
    #         �ؿ��ƤӽФ������ִ�Ϣ�������ȯ����CPU�㳰ȯ����syslog
    #         �ʤɤΥ����ɤ��ɲä��������Ǥ����Ѥ�����
    #================================================================
    def set_code(hProcUnitInfo, sEvalCode, bExpression = true)
      check_class(Hash, hProcUnitInfo) # �����ɤ��ɲä������ñ�̾���
      check_class(String, sEvalCode)   # ���Ϥ�����������
      check_class(Bool, bExpression)   # �����ɤ����Ǥ��뤫�ɤ����ʥǥե���ȡ�true��

      if (bExpression == true)
        # ���ξ��Ͻ���ʸ����˥��ߥ�������Ϳ����
        sEvalCodeSemicolon = sEvalCode + ";"
        @aElement.push({:atr => :expression, :proc_unit => hProcUnitInfo, :code => sEvalCodeSemicolon})
      else
        # ʸ�ξ��Ϥ��Τޤ޳�Ǽ����
        @aElement.push({:atr => :statement,  :proc_unit => hProcUnitInfo, :code => sEvalCode})
      end
    end


    #================================================================
    # ������: �����å��ݥ���Ȥ��������륳���ɤ����Ǥ��ݻ�����
    #================================================================
    def set_checkpoint(hProcUnitInfo)
      check_class(Hash, hProcUnitInfo) # �����å��ݥ���Ȥ��ɲä������ñ�̾���

      if (@cConf.is_asp?())
        @aElement.push({:atr => :check,    :proc_unit => hProcUnitInfo})
      elsif (@cConf.is_fmp?())
        @aElement.push({:atr => :check_mp, :proc_unit => hProcUnitInfo})
      else
        abort(ERR_MSG % [__FILE__, __LINE__])
      end
    end


    #================================================================
    # ������: ��������å��ݥ���Ȥ��������륳���ɤ����Ǥ��ݻ�����
    #================================================================
    def set_checkpoint_zero(hProcUnitInfo)
      check_class(Hash, hProcUnitInfo) # �����å��ݥ���Ȥ��ɲä������ñ�̾���

      if (@cConf.is_asp?())
        @aElement.push({:atr => :check_zero,    :proc_unit => hProcUnitInfo})
      else
        abort(ERR_MSG % [__FILE__, __LINE__])
      end
    end


    #================================================================
    # ������: �����å��ݥ���Ȥ��Ԥĥ����ɤ����Ǥ��ݻ�����
    #================================================================
    def wait_checkpoint(hProcUnitInfo)
      check_class(Hash, hProcUnitInfo) # �����å��ݥ���Ȥ��ԤĽ���ñ�̾���

      unless (@cConf.is_asp?())
        abort(ERR_MSG % [__FILE__, __LINE__])
      end

      @aElement.push({:atr => :wait, :proc_unit => hProcUnitInfo})
    end


    #================================================================
    # ������: �ǽ������å��ݥ���Ȥ��������륳���ɤ����Ǥ��ݻ�����
    #================================================================
    def set_checkfinish(hProcUnitInfo)
      check_class(Hash, hProcUnitInfo) # �����å��ݥ���Ȥ��ɲä������ñ�̾���

      if (@cConf.is_asp?())
        @aElement.push({:atr => :check_finish,    :proc_unit => hProcUnitInfo})
      elsif (@cConf.is_fmp?())
        @aElement.push({:atr => :check_finish_mp, :proc_unit => hProcUnitInfo})
      else
        abort(ERR_MSG % [__FILE__, __LINE__])
      end
    end


    #================================================================
    # ������: WaitCheckSync��Ԥ������ɤ����Ǥ��ݻ�����
    #================================================================
    def set_wait_check_sync(hProcUnitInfo, nPrcid)
      check_class(Hash, hProcUnitInfo) # waitCP���ɲä������ñ�̾���
      check_class(Integer, nPrcid)     # �Ԥ��оݤΥץ��å�ID

      unless (@cConf.is_fmp?())
        abort(ERR_MSG % [__FILE__, __LINE__])
      end

      @aElement.push({:atr => :waitcp, :proc_unit => hProcUnitInfo, :prcid => nPrcid})
    end


    #================================================================
    # ������: StateSync��Ԥ������ɤ����Ǥ��ݻ�����
    #================================================================
    def set_state_sync(hProcUnitInfo, sTargetTask, sTargetState)
      check_class(Hash, hProcUnitInfo)    # waitCP���ɲä������ñ�̾���
      check_class(String, sTargetTask)    # �Ԥ��оݥ�����ID
      check_class(String, sTargetState)   # �Ԥ��оݾ���

      unless (@cConf.is_fmp?())
        abort(ERR_MSG % [__FILE__, __LINE__])
      end

      set_code(hProcUnitInfo, "#{FNC_STATE_SYNC}(\"#{hProcUnitInfo[:id]}\", \"#{sTargetTask}\", #{sTargetTask}, \"#{sTargetState}\", #{sTargetState})")
    end


    #================================================================
    # ������: WaitFinishSync��Ԥ������ɤ����Ǥ��ݻ�����
    #================================================================
    def set_wait_finish_sync(hProcUnitInfo)
      check_class(Hash, hProcUnitInfo)  # WaitFinishSync���ɲä������ñ�̾���

      unless (@cConf.is_fmp?())
        abort(ERR_MSG % [__FILE__, __LINE__])
      end

      set_code(hProcUnitInfo, "#{FNC_WAIT_FINISH_SYNC}(\"#{hProcUnitInfo[:id]}\")")
    end


    #================================================================
    # ������: �ᥤ�󥿥�����ͥ���٤�TTG_MAIN_PRI�Ǥʤ���������
    #         chg_pri�򤹤륳���ɤ�cElement�����ꤹ��
    #================================================================
    def set_chg_pri_main_task(hProcUnitInfo)
      check_class(Hash, hProcUnitInfo)  # chg_pri_main_task�������ɲä������ñ�̾��������

      @aElement.push({:atr => :chg_pri_main_task})
      set_code(hProcUnitInfo, "#{FNC_CHG_PRI_MAIN_TASK}()")
    end


    #================================================================
    # ������: BarrierSync��Ԥ������ɤ����Ǥ��ݻ�����
    #================================================================
    def set_barrier_sync(aProcUnitInfo)
      check_class(Array, aProcUnitInfo) # �ХꥢƱ�����ɲä������ñ�̾��������

      unless (@cConf.is_fmp?())
        abort(ERR_MSG % [__FILE__, __LINE__])
      end

      aProcUnitInfo.each{ |hProcUnitInfo|
        @aElement.push({:atr => :barrier, :proc_unit => hProcUnitInfo, :num => aProcUnitInfo.size})
      }
    end


    #================================================================
    # ������: dormant�Υ��������Ф���ޥ����졼�Ƚ�����Ԥ������ɤ���
    #         �Ǥ��ݻ�����
    #================================================================
    def set_migrate_task(hMainTaskInfo, sTargetTask, nTargetPrcid)
      check_class(Hash, hMainTaskInfo)    # �ᥤ�󥿥����ν���ñ�̾���
      check_class(String, sTargetTask)    # �Ԥ��оݥ�����ID
      check_class(Integer, nTargetPrcid)  # �ޥ����졼�Ȥ��������ץ��å�ID

      unless (@cConf.is_fmp?())
        abort(ERR_MSG % [__FILE__, __LINE__])
      end

      @aElement.push({:atr => :migrate_func})
      set_code(hMainTaskInfo, "#{FNC_MIGRATE_TASK}(#{sTargetTask}, #{nTargetPrcid})")
    end


    #================================================================
    # ������: �ٱ������Ԥ������ɤ����Ǥ��ݻ�����
    #================================================================
    def set_delay_loop(hProcUnitInfo)
      check_class(Hash, hProcUnitInfo)  # �ٱ������Ԥ�����ñ�̾���

      set_comment(hProcUnitInfo, CMT_WAIT_SPIN_LOOP)
      set_local_var(hProcUnitInfo[:id], "i", VAR_VOLATILE_ULONG_T)
      set_code(hProcUnitInfo, "for (i = 0; i < #{@cConf.get_wait_spin_loop()}; i++)")
    end


    #================================================================
    # ������: ����ñ��̾�Ⱥǽ�Ū�ʵ�ư�������ݻ�����
    #================================================================
    def set_proc_unit(sProcUnitID, nFinalBootCnt = 0)
      check_class(String, sProcUnitID)    # �ɲä������ñ��ID
      check_class(Integer, nFinalBootCnt) # �ǽ�Ū�ʵ�ư���

      @aElement.push({:atr => :proc_unit, :proc_unit_id => sProcUnitID, :fbootcnt => nFinalBootCnt})
    end


    #================================================================
    # ������: �������ѿ���������ɤ����Ǥ��ݻ�����
    #================================================================
    def set_local_var(sProcUnitID, sVarName, sVarType, snVarValue = nil)
      check_class(String, sProcUnitID)                 # �����Ȥ��ɲä������ñ��ID
      check_class(String, sVarName)                    # �ѿ�̾
      check_class(String, sVarType)                    # �ѿ��η�
      check_class([String, Integer], snVarValue, true) # �ѿ��ν����

      @aElement.push({:atr => :localvar, :proc_unit_id => sProcUnitID, :name => sVarName, :type => sVarType, :value => snVarValue})
    end


    #================================================================
    # ������: �����Х��ѿ���������ɤ����Ǥ��ݻ�����
    #================================================================
    def set_global_var(sVarName, sVarType, snVarValue = nil)
      check_class(String, sVarName)                           # �ѿ�̾
      check_class(String, sVarType)                           # �ѿ��η�
      check_class([String, Integer, *Bool], snVarValue, true) # �ѿ��ν����

      @aElement.push({:atr => :globalvar, :name => sVarName, :type => sVarType, :value => snVarValue})
    end


    #================================================================
    # ������: �ץ�ȥ�������������ɤ����Ǥ��ݻ�����
    #================================================================
    def set_header(sProcUnitID, sObjectType, aFuncArgs = nil)
      check_class(String, sProcUnitID)    # �ץ�ȥ�����������ɲä������ñ��
      check_class(String, sObjectType)    # ����ñ�̤Υ��֥������ȥ����סʴؿ��ξ���IMC_FUNC_TYPE��
      check_class(Array, aFuncArgs, true) # ����������ʴؿ��ξ��Τߡ�

      @aElement.push({:atr => :header, :proc_unit_id => sProcUnitID, :type => sObjectType, :args => aFuncArgs})
    end


    #================================================================
    # ������: ��ŪAPI�����Ǥ��ݻ�����
    #================================================================
    def set_config(sCode, sClass = nil)
      check_class(String, sCode)        # �ɲä�����ŪAPI
      check_class(String, sClass, true) # �ɲä����оݥ��饹(�ǥե���� nil)

      @aElement.push({:atr => :config, :code => sCode, :class => sClass})
    end


    #================================================================
    # ������: �����ȥ����ɤ����Ǥ��ݻ�����
    #================================================================
    def set_comment(hProcUnitInfo, sComment, lAtr = :comment)
      check_class(Hash, hProcUnitInfo) # �����Ȥ��ɲä������ñ�̾���
      check_class(String, sComment)    # �ɲä��륳����
      check_class(Symbol, lAtr)        # ��Ϳ����°���ʥǥե���� :comment��

      @aElement.push({:atr => lAtr, :proc_unit => hProcUnitInfo, :code => sComment})
    end


    #================================================================
    # ������: �֥�å��ζ�������������̿����ݻ�����
    #================================================================
    def set_block_delimiter()
      if (lMode == :block)
        @aElement.push({:atr => :delimiter_cmd})
      end
    end


    #================================================================
    # ������: �ʹߤν��ϥ����ɤ򥤥�ǥ�Ȥ���̿����ݻ�����
    #================================================================
    def set_indent(nTabs = 1)
      check_class(Integer, nTabs) # ����ǥ�Ȥο����ʥǥե���� 1��

      @aElement.push({:atr => :indent_cmd, :num => nTabs})
    end


    #================================================================
    # ������: ����ǥ��̿���������̿����ݻ�����
    #================================================================
    def unset_indent()
      @aElement.push({:atr => :unindent_cmd})
    end


    #================================================================
    # ������: �ؿ������ľ��˽��Ϥ���ץ쥳���ɤ����Ǥ��ݻ�����
    #================================================================
    def set_pre_code(sProcUnitID, sPreCode, bExpression = true)
      check_class(String, sProcUnitID)  # �����ɤ��ɲä������ñ��ID
      check_class(String, sPreCode)     # ���Ϥ������ץ쥳����
      check_class(Bool, bExpression)    # �����ɤ����Ǥ��뤫�ɤ����ʥǥե���ȡ�true��

      if (bExpression == true)
        # ���ξ��Ͻ���ʸ����˥��ߥ�������Ϳ����
        sPreCodeSemicolon = sPreCode + ";"
        @aElement.push({:atr => :precode, :proc_unit => sProcUnitID, :code => sPreCodeSemicolon})
      else
        # ʸ�ξ��Ϥ��Τޤ޳�Ǽ����
        @aElement.push({:atr => :precode, :proc_unit => sProcUnitID, :code => sPreCode})
      end
    end


    #================================================================
    # ������: �ؿ�����κǸ�˽��Ϥ���ݥ��ȥ����ɤ����Ǥ��ݻ�����
    #================================================================
    def set_post_code(sProcUnitID, sPostCode, bExpression = true)
      check_class(String, sProcUnitID)  # �����ɤ��ɲä������ñ��ID
      check_class(String, sPostCode)    # ���Ϥ������ݥ��ȥ�����
      check_class(Bool, bExpression)    # �����ɤ����Ǥ��뤫�ɤ����ʥǥե���ȡ�true��

      if (bExpression == true)
        # ���ξ��Ͻ���ʸ����˥��ߥ�������Ϳ����
        sPostCodeSemicolon = sPostCode + ";"
        @aElement.push({:atr => :postcode, :proc_unit => sProcUnitID, :code => sPostCodeSemicolon})
      else
        # ʸ�ξ��Ϥ��Τޤ޳�Ǽ����
        @aElement.push({:atr => :postcode, :proc_unit => sProcUnitID, :code => sPostCode})
      end
    end


    #================================================================
    # ������: IMCodeElement��pp��긫�䤹�������������ƽ��Ϥ���
    #================================================================
    def p_code(lOption = :all)
      # [atr]         [proc]   [other parameters]
      # api           proc,    syscall,          var
      # ercd          proc,    ret,              var
      # assert        proc,                      var,     value
      # code          proc,    code
      # check(mp)     proc
      # zero          proc
      # finish(mp)    proc
      # waitcp        proc,    prcid
      # barrier       proc,    num
      # proc_unit     proc_id, fbootcnt
      # localvar      proc_id, name,    type,             value
      # globalvar              name,    type,             value
      # header        proc_id,          type,    var
      # config                 code,    class
      # comment       proc,    code
      # delimiter_cmd
      # precode       proc_id, code
      # postcode      proc_id, code
      puts "[atr]".center(15) + "|" + "[proc_unit]".center(14) + "|" + "[other_parameters]"
      puts "-" * 15 + "+" + "-" * 14 + "+" + "-" * 20
      @aElement.each{ |hElement|
        if (hElement[:atr] == :delimiter_cmd)
          puts ""; next
        end
        print "#{hElement[:atr]}".ljust(15) + "|"

        print "#{hElement[:proc_unit][:id].sub(/.*_(\w+\z)/, "\\1")}".ljust(8) + "|" if (hElement[:proc_unit])
        print "#{hElement[:proc_unit_id].sub(/.*_(\w+\z)/, "\\1")}".ljust(8)   + "|" if (hElement[:proc_unit_id])
        print "".ljust(8) + "|" unless (hElement[:proc_unit] || hElement[:proc_unit_id])
        print "#{hElement[:proc_unit][:bootcnt]}".ljust(2) + "|" if (hElement[:proc_unit])
        print "#{hElement[:proc_unit][:prcid]}".ljust(2)   + "|" if (hElement[:proc_unit])
        print "".ljust(2) + "|" + "".ljust(2) + "|" unless (hElement[:proc_unit])
        print "#{hElement[:syscall]}, "   if (hElement[:syscall])
        print "#{hElement[:ret]}, "       if (hElement[:ret])
        print "#{hElement[:code]}, "      if (hElement[:code])
        print "#{hElement[:prcid]}, "     if (hElement[:prcid])
        print "#{hElement[:num]}, "       if (hElement[:num])
        print "#{hElement[:fbootcnt]}, "  if (hElement[:fbootcnt])
        print "#{hElement[:name]}, "      if (hElement[:name])
        print "#{hElement[:type]}, "      if (hElement[:type])
        print "#{hElement[:class]}, "     if (hElement[:class])
        print "#{hElement[:var]}, "       if (hElement[:var])
        print "#{hElement[:value]}, "     if (hElement[:value])
        print "#{hElement[:code]}, "      if (hElement[:precode])
        print "#{hElement[:code]}, "      if (hElement[:postcode])
        puts ""
      }
    end

  end
end
