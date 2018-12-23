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
#  $Id: ProcessUnit.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#
require "common/bin/CommonModule.rb"
require "common/bin/Config.rb"
require "common/bin/process_unit/Variable.rb"
require "common/bin/IMCodeElement.rb"
require "ttc/bin/process_unit/ProcessUnit.rb"

#=====================================================================
# CommonModule
#=====================================================================
module CommonModule
  #===================================================================
  # ���饹̾: ProcessUnit
  # ��    ��: ����ñ�̥��֥������Ȥξ����������륯�饹
  #===================================================================
  class ProcessUnit
    include CommonModule

    attr_accessor :hState, :sObjectID, :sObjectType

    #=================================================================
    # ��  ��: ����ñ�̥��֥������Ȥν����
    #=================================================================
    def initialize(sObjectID, hObjectInfo, sObjectType, aPath, bIsPre)
      check_class(String, sObjectID)    # ���֥�������ID
      check_class(Hash, hObjectInfo)    # ���֥������Ⱦ���
      check_class(String, sObjectType)  # ���֥������ȥ�����
      check_class(Array, aPath)         # �롼�Ȥ���Υѥ�
      check_class(Bool, bIsPre)         # pre_condition�⤫

      @cConf                  = Config.new()
      @hState                 = {}
      @aSpecifiedDoAttributes = []

      @sObjectID   = sObjectID
      @sObjectType = sObjectType
      @aPath       = aPath + [@sObjectID]

      @bConvertState = false  # state°���������ݻ��Ѥ��ͤ��֤���������(TESRY��TTS_RUN�ʤɻ��ꤵ�줿���˥��顼���ФǤ��ʤ�)

      # ����ñ�̥��饹������ʬ
      @hState[TSR_PRM_STATE]   = nil  # ����[������/���顼��ϥ�ɥ�/�����ϥ�ɥ�/�������㳰/����ߥϥ�ɥ�/����ߥ����ӥ��롼����]
      @hState[TSR_PRM_LEFTTMO] = nil  # ���ֻ���[������/���顼��ϥ�ɥ�/�����ϥ�ɥ�]
      @hState[TSR_PRM_VAR]     = nil  # �ѿ�����[������ñ��]
      @hState[TSR_PRM_EXINF]   = nil  # ��ĥ����[������/���顼��ϥ�ɥ�/�����ϥ�ɥ�/����ߥ����ӥ��롼����/������롼����/��λ�롼����]
      @hState[TSR_PRM_HDLSTAT] = nil  # ���顼��ϥ�ɥ����[���顼��ϥ�ɥ�/�����ϥ�ɥ�/�������㳰/����ߥϥ�ɥ�/����ߥ����ӥ��롼����/CPU�㳰�ϥ�ɥ�]
      @hState[TSR_PRM_ACTPRC]  = nil  # ����ư�����դ��ץ��å�ID[������/���顼��ϥ�ɥ�/�����ϥ�ɥ�]
      @hState[TSR_PRM_BOOTCNT] = nil  # ����ñ�̤ε�ư���[������/���顼��ϥ�ɥ�/�����ϥ�ɥ�/�������㳰/����ߥϥ�ɥ�/����ߥ����ӥ��롼����/CPU�㳰�ϥ�ɥ�]
      @hState[TSR_PRM_PRCID]   = nil  # �ץ��å�ID[������/���顼��ϥ�ɥ�/�����ϥ�ɥ�]
      @hState[TSR_PRM_CLASS]   = nil  # ���饹[������ñ��]
      @hState[TSR_PRM_INTNO]   = nil  # ������ֹ�[����ߥϥ�ɥ�/����ߥ����ӥ��롼����]
      @hState[TSR_PRM_INTPRI]  = nil  # �����ͥ����[����ߥϥ�ɥ�/����ߥ����ӥ��롼����]
      @hState[TSR_PRM_SPINID]  = nil  # ���ԥ��å�ID[������/���顼��ϥ�ɥ�/�����ϥ�ɥ�/�������㳰/CPU�㳰�ϥ�ɥ�/����ߥϥ�ɥ�/����ߥ����ӥ��롼����]
      @hState[TSR_PRM_ATR]     = nil  # °��[�����ϥ�ɥ�/����ߥϥ�ɥ�/����ߥ����ӥ��롼����]

      # TASK
      @hState[TSR_PRM_ITSKPRI] = nil  # ��ư��ͥ����
      @hState[TSR_PRM_TSKPRI]  = nil  # ����ͥ����
      @hState[TSR_PRM_TSKWAIT] = nil  # �Ԥ��װ�
      @hState[TSR_PRM_WOBJID]  = nil  # �Ԥ����֤ˤ������Ԥ��о�
      @hState[TSR_PRM_ACTCNT]  = nil  # ��ư�׵ᥭ�塼���󥰿�
      @hState[TSR_PRM_WUPCNT]  = nil  # �����׵ᥭ�塼���󥰿�
      @hState[TSR_PRM_PORDER]  = nil  # �¹�(��ǽ)���ֻ��Υ�ǥ����塼��Ǥν��

      # CYCLE
      @hState[TSR_PRM_CYCPHS]  = nil  # ����
      @hState[TSR_PRM_CYCTIM]  = nil  # ����

      # TASK_EXC
      @hState[TSR_PRM_PNDPTN]  = nil  # �������㳰����α�㳰�װ��ѥ�����
      @hState[TSR_PRM_TEXPTN]  = nil  # �������㳰���㳰�װ��ѥ�����
      @hState[TSR_PRM_TASK]    = nil  # �������㳰��Ϣ������

      # INTHDR
      @hState[TSR_PRM_INHNO]   = nil  # ����ߥϥ�ɥ��ֹ�

      # ISR
      @hState[TSR_PRM_ISRPRI]  = nil  # ����ߥ����ӥ��롼����ͥ����

      # EXCEPTION
      @hState[TSR_PRM_EXCNO]   = nil  # CPU�㳰�ϥ�ɥ��ֹ�

      # INIRTN��TERRTN
      @hState[TSR_PRM_DO]      = nil  # �����/��λ�롼������Ǽ¹Ԥ������
      @hState[TSR_PRM_GLOBAL]  = nil  # �����Х�����/��λ�롼�����⤫�ɤ���

      pre_attribute_check(hObjectInfo, aPath + [@sObjectID], bIsPre)
      store_object_info(hObjectInfo)
    end

    #=================================================================
    # ��  ��: �ƥ��ȥ��ʥꥪ���̤����ñ�̥��֥������ȥǡ�����
    #         @hState������
    #=================================================================
    def store_object_info(hObjectInfo)
      check_class(Hash, hObjectInfo)  # ���֥������Ⱦ���

      # ��Ǽ
      set_specified_attribute(hObjectInfo)
      hObjectInfo.each{|atr, val|
        case atr
        when TSR_PRM_TYPE
          # ���⤷�ʤ�

        when TSR_PRM_TSKSTAT, TSR_PRM_ALMSTAT, TSR_PRM_CYCSTAT, TSR_PRM_TEXSTAT, TSR_PRM_INTSTAT
          if (GRP_OBJECT_STATE.has_key?(val))
            @hState[TSR_PRM_STATE] = GRP_OBJECT_STATE[val]
            @bConvertState = true
          else
            @hState[TSR_PRM_STATE] = val
          end

        when TSR_PRM_LEFTTIM, TSR_PRM_LEFTTMO
          @hState[TSR_PRM_LEFTTMO] = val

        when TSR_PRM_VAR
          @hState[atr] = {}
          if (val.is_a?(Hash))
            val.each{|sVarName, var|
              @hState[atr][sVarName] = Variable.new(sVarName, var, @aPath + [TSR_PRM_VAR])
            }
          else
            @hState[atr] = val
          end

        when TSR_PRM_CYCATR, TSR_PRM_INTATR
          @hState[TSR_PRM_ATR] = val

        else
          @hState[atr] = val

        end
      }
    end

    #=================================================================
    # ��  ��: ref������cElement���ɲä���
    #=================================================================
    def gc_obj_ref(cElement, hProcUnitInfo, bContext, bCpuLock)
      check_class(IMCodeElement, cElement) # �������
      check_class(Hash, hProcUnitInfo)     # ����ñ�̾���
      check_class(Bool, bContext)          # ̤����(SCObject¦�Ȥ��о����Τ���)
      check_class(Bool, bCpuLock)          # ̤����(SCObject¦�Ȥ��о����Τ���)


      cElement.set_local_var(hProcUnitInfo[:id], @sRefStrVar, @sRefStrType)

      # �������㳰�ξ�硤���ꤹ��ID�ϴ�Ϣ���륿����ID�Ȥ���
      if (@sObjectType == TSR_OBJ_TASK_EXC)
        cElement.set_syscall(hProcUnitInfo, "#{@sRefAPI}(#{@hState[TSR_PRM_TASK]}, &#{@sRefStrVar})")
      else
        cElement.set_syscall(hProcUnitInfo, "#{@sRefAPI}(#{@sObjectID}, &#{@sRefStrVar})")
      end

      # °��
      if (!@hState[TSR_PRM_ATR].nil?())
        cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{@sRefAtr}", @hState[TSR_PRM_ATR])  # CYCLE�Τ�
      end

      # ����
      if (!@hState[TSR_PRM_STATE].nil?())
        # ���ԥ��å������Ԥ��ξ���ref����뤳�Ȥ��ʤ�
        if (@hState[TSR_PRM_STATE] == TSR_STT_R_WAITSPN)
          abort(ERR_MSG % [__FILE__, __LINE__])
        else
          cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{@sRefState}", @hState[TSR_PRM_STATE])
        end
      end

      # ����ͥ����(���������ٻ߾��֤ξ��ϻ��Ȥ��ʤ�)
      if (!@hState[TSR_PRM_TSKPRI].nil?() && (@hState[TSR_PRM_STATE] != KER_TTS_DMT))
        cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{STR_TSKPRI}", @hState[TSR_PRM_TSKPRI])
      end

      # ��ư��ͥ����
      if (!@hState[TSR_PRM_ITSKPRI].nil?())
        cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{STR_ITSKPRI}", @hState[TSR_PRM_ITSKPRI])
      end

      # ���ֻ���
      if (@sObjectType == TSR_OBJ_TASK)
        # ���������ٻ߾��֤ξ��ϻ��Ȥ��ʤ�
        if (!@hState[TSR_PRM_LEFTTMO].nil?() && (@hState[TSR_PRM_STATE] != KER_TTS_DMT))
          cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{STR_LEFTTMO}", "#{CST_TMO}#{@hState[TSR_PRM_LEFTTMO]}U")
        end
      else
        # ���顼��ϥ�ɥ顤�����ϥ�ɥ�
        if (!@hState[TSR_PRM_LEFTTMO].nil?())
          cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{STR_LEFTTIM}", @hState[TSR_PRM_LEFTTMO])
        end
      end

      # ��ǥ����塼��Ǥν��(���������ٻ߾��֤ξ��ϻ��Ȥ��ʤ�)
      if (!@hState[TSR_PRM_PORDER].nil?() && (@hState[TSR_PRM_STATE] != KER_TTS_DMT))
        cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{STR_PORDER}", @hState[TSR_PRM_PORDER])
      end

      # ��ư�׵ᥭ�塼���󥰿�
      if (!@hState[TSR_PRM_ACTCNT].nil?())
        cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{STR_ACTCNT}", @hState[TSR_PRM_ACTCNT])
      end

      # �����׵ᥭ�塼���󥰿�(���������ٻ߾��֤ξ��ϻ��Ȥ��ʤ�)
      if (!@hState[TSR_PRM_WUPCNT].nil?() && (@hState[TSR_PRM_STATE] != KER_TTS_DMT))
        cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{STR_WUPCNT}", @hState[TSR_PRM_WUPCNT])
      end

      # ��ĥ����(�������㳰�ξ��ϻ��ȤǤ��ʤ�)
      if (!@hState[TSR_PRM_EXINF].nil?() && (@sObjectType != TSR_OBJ_TASK_EXC))
        cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{@sRefExInf}", @hState[TSR_PRM_EXINF])
      end

      # �ץ��å�ID(�������㳰�Ǥ�ref���ʤ�)
      if (!@hState[TSR_PRM_PRCID].nil?() && (sObjectType != TSR_OBJ_TASK_EXC))
        cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{@sRefPrcID}", @hState[TSR_PRM_PRCID])
      end

      # ����ư�����դ��ץ��å�ID
      if (!@hState[TSR_PRM_ACTPRC].nil?())
        cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{@sRefActPrc}", @hState[TSR_PRM_ACTPRC])
      end

      # �Ԥ��о�(���������ٻ߾��֤ξ��ϻ��Ȥ��ʤ�)
      if (!@hState[TSR_PRM_WOBJID].nil?() && (@hState[TSR_PRM_STATE] != KER_TTS_DMT))
        if (@hState[TSR_PRM_WOBJID] == TSR_STT_SLEEP)
          cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{STR_TSKWAIT}", KER_TTW_SLP)
        elsif (@hState[TSR_PRM_WOBJID] == TSR_STT_DELAY)
          cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{STR_TSKWAIT}", KER_TTW_DLY)
        else
          cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{STR_WOBJID}", @hState[TSR_PRM_WOBJID])
        end
      end

      # ����
      if (!@hState[TSR_PRM_CYCPHS].nil?())
        cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{STR_CYCPHS}", @hState[TSR_PRM_CYCPHS])
      end

      # ����
      if (!@hState[TSR_PRM_CYCTIM].nil?())
        cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{STR_CYCTIM}", @hState[TSR_PRM_CYCTIM])
      end

      # ��α�㳰�װ��ѥ�����
      if (!@hState[TSR_PRM_PNDPTN].nil?())
        cElement.set_assert(hProcUnitInfo, "#{@sRefStrVar}.#{STR_PNDPTN}", @hState[TSR_PRM_PNDPTN])
      end
    end

    #=================================================================
    # ��  ��: ����ñ�̤������ѿ����ͤ���Ӥ��륳���ɤ�cElement�˳�Ǽ��
    #         ��
    #=================================================================
    def gc_assert_value(cElement, hProcUnitInfo)
      check_class(IMCodeElement, cElement) # �������
      check_class(Hash, hProcUnitInfo)     # ����ñ�̾���

      hState[TSR_PRM_VAR].each{|sValName, cVariable|
        cVariable.gc_assert_value(cElement, hProcUnitInfo)
      }
    end

    #=================================================================
    # ��  ��: �ץ��å�ID���֤�
    #=================================================================
    def get_process_id()
      return @hState[TSR_PRM_PRCID] == nil ? 1 : @hState[TSR_PRM_PRCID] # [Integer]�ץ��å�ID
    end

    #=================================================================
    # ��  ��: ������롼����Υ����ɤ����������֤�
    #=================================================================
    def gc_ini_rtn(bFirstFlg)
      check_class(Bool, bFirstFlg)  # �ǽ�ν�����롼���󤫤ɤ���

      cElement = IMCodeElement.new()

      # ����ñ�����(bootcnt��0����)
      cElement.set_proc_unit(@sObjectID, TTG_MAIN_BOOTCNT)

      # ���Ȥν���ñ�̾������
      hIniRtnInfo = {:id => @sObjectID, :prcid => @hState[TSR_PRM_PRCID], :bootcnt => TTG_MAIN_BOOTCNT}

      # ASP����Ƭ�ν�����롼����ξ�硤�����������Ԥ�
      if ((bFirstFlg == true) && @cConf.is_asp?())
        # �ƥ��ȥ饤�֥�����ѿ������
        cElement.set_code(hIniRtnInfo, FNC_INITIALIZE_TEST_LIB)
      end

      # �ƥ���ID���Ϥ�syslog����
      cElement.set_code(hIniRtnInfo, "syslog_0(LOG_NOTICE, \"#{@sObjectID}: Start\")")

      # ������롼�����ɬ�פʤ��٤ƤΥ����ɺ���
      gc_ini_ter_rtn_info(cElement, hIniRtnInfo, bFirstFlg)

      # ������롼������˥����å��ݥ���Ȥ�����
      cElement.set_checkpoint(hIniRtnInfo)

      # �ƥ���ID��λ��syslog����
      cElement.set_code(hIniRtnInfo, "syslog_0(LOG_NOTICE, \"#{@sObjectID}: OK\")")

      return cElement # [IMCodeElement] �������
    end

    #=================================================================
    # ��  ��: ��λ�롼����Υ����å��ݥ���Ȱʳ��Υ����ɤ����������֤�
    #=================================================================
    def gc_ter_rtn_info()
      cElement = IMCodeElement.new()

      # ����ñ�����(bootcnt��0����)
      cElement.set_proc_unit(@sObjectID, TTG_MAIN_BOOTCNT)

      # ���Ȥν���ñ�̾������
      hTerRtnInfo = {:id => @sObjectID, :prcid => @hState[TSR_PRM_PRCID], :bootcnt => TTG_MAIN_BOOTCNT}

      # ���顼��ȯ�����Ƥ�����Ͻ�λ�롼�����¹Ԥ�����return����
      cElement.set_local_var(hTerRtnInfo[:id], VAR_STATE, TYP_BOOL_T)
      cElement.set_code(hTerRtnInfo, "#{VAR_STATE} = #{FNC_GET_CP_STATE}()")
      cElement.set_code(hTerRtnInfo, "if (#{VAR_STATE} == false) {", false)
      cElement.set_indent(1)
      cElement.set_code(hTerRtnInfo, "return")
      cElement.unset_indent()
      cElement.set_code(hTerRtnInfo, "}")
      cElement.set_block_delimiter()

      # �ƥ���ID���Ϥ�syslog����
      cElement.set_code(hTerRtnInfo, "syslog_0(LOG_NOTICE, \"#{@sObjectID}: Start\")")

      # ������롼�����ɬ�פʤ��٤ƤΥ����ɺ���
      gc_ini_ter_rtn_info(cElement, hTerRtnInfo, false)

      return cElement # [IMCodeElement] �������
    end

    #=================================================================
    # ��  ��: ��λ�롼����Υ����å��ݥ���ȤΥ����ɤ����������֤�
    #=================================================================
    def gc_ter_rtn_checkpoint()
      cElement = IMCodeElement.new()

      # ���Ȥν���ñ�̾������
      hTerRtnInfo = {:id => @sObjectID, :prcid => @hState[TSR_PRM_PRCID], :bootcnt => TTG_MAIN_BOOTCNT}

      cElement.set_checkpoint(hTerRtnInfo)

      # �ƥ���ID��λ��syslog����
      cElement.set_code(hTerRtnInfo, "syslog_0(LOG_NOTICE, \"#{@sObjectID}: OK\")")

      return cElement # [IMCodeElement] �������
    end

    #=================================================================
    # ��  ��: �ƥ��Ƚ�λ��å��������ϤΥ����ɤ����������֤�
    #=================================================================
    def gc_finish_message()
      cElement = IMCodeElement.new()

      # ���Ȥν���ñ�̾������
      hTerRtnInfo = {:id => @sObjectID, :prcid => @hState[TSR_PRM_PRCID], :bootcnt => TTG_MAIN_BOOTCNT}

      cElement.set_local_var(hTerRtnInfo[:id], VAR_STATE, TYP_BOOL_T)
      cElement.set_code(hTerRtnInfo, "#{VAR_STATE} = #{FNC_GET_CP_STATE}()")
      cElement.set_code(hTerRtnInfo, "if (#{VAR_STATE} == true) {", false)
      cElement.set_indent(1)

      # GCOV�ν���
      # FMP�ξ���GCOV���ѤΥ����Х뽪λ�롼����ǽ��Ϥ��뤿�ᡤASP�Τ�
      if (@cConf.enable_gcov?() && @cConf.is_asp?())
        cElement.set_code(hTerRtnInfo, FNC_GCOV_C_RESUME)
        cElement.set_code(hTerRtnInfo, FNC_GCOV_C_DUMP)
      end

      if (@cConf.is_asp?())
        cElement.set_code(hTerRtnInfo, "syslog_0(LOG_NOTICE, \"#{TTG_FINISH_MESSAGE}\")")
      else
        cElement.set_code(hTerRtnInfo, "syslog_0(LOG_NOTICE, \"PE #{hTerRtnInfo[:prcid]} : #{TTG_FINISH_MESSAGE}\")")
      end
      cElement.unset_indent()
      cElement.set_code(hTerRtnInfo, "}")

      return cElement # [IMCodeElement] �������
    end

    #=================================================================
    # ��  ��: �����/��λ�롼�����ɬ�פʤ��٤ƤΥ����ɺ���
    #=================================================================
    def gc_ini_ter_rtn_info(cElement, hRtnInfo, bFirstFlg)
      check_class(IMCodeElement, cElement) # �������
      check_class(Hash, hRtnInfo)          # ����ñ�̾���
      check_class(Bool, bFirstFlg)         # ���Ǥʤ�������롼���󤫤ɤ���

      # �إå�����
      cElement.set_header(@sObjectID, @sObjectType)

      # ����ե����ե��������
      cElement.set_config("#{@sCfgAPI}({#{KER_TA_NULL}, #{@hState[TSR_PRM_EXINF]}, #{@sObjectID.downcase}});", @hState[TSR_PRM_CLASS])

      # ��ĥ����λ���
      cElement.set_assert(hRtnInfo, VAR_EXINF, @hState[TSR_PRM_EXINF])

      # GCOV�����γ���
      if (@cConf.enable_gcov?())
        # ASP�Ǻǽ�ν�����롼����ξ�硤���ǽ����������
        if (bFirstFlg == true && @cConf.is_asp?())
          cElement.set_code(hRtnInfo, FNC_GCOV_TTG_C_PAUSE)
        end
        if (@hState[TSR_PRM_DO][TSR_PRM_GCOV] == true)
          cElement.set_code(hRtnInfo, FNC_GCOV_TTG_C_RESUME)
        end
      end

      # �¹Ԥ��륳����
      if (@hState[TSR_PRM_DO].has_key?(TSR_PRM_SYSCALL))
        if (@hState[TSR_PRM_DO].has_key?(TSR_PRM_ERCD))
          cElement.set_syscall(hRtnInfo, @hState[TSR_PRM_DO][TSR_PRM_SYSCALL], @hState[TSR_PRM_DO][TSR_PRM_ERCD])
        elsif (@hState[TSR_PRM_DO].has_key?(TSR_PRM_ERUINT))
          cElement.set_syscall(hRtnInfo, @hState[TSR_PRM_DO][TSR_PRM_SYSCALL], @hState[TSR_PRM_DO][TSR_PRM_ERUINT], TYP_ER_UINT)
        elsif (@hState[TSR_PRM_DO].has_key?(TSR_PRM_BOOL))
          cElement.set_syscall(hRtnInfo, @hState[TSR_PRM_DO][TSR_PRM_SYSCALL], @hState[TSR_PRM_DO][TSR_PRM_BOOL], TYP_BOOL_T)
        else
          cElement.set_syscall(hRtnInfo, @hState[TSR_PRM_DO][TSR_PRM_SYSCALL], nil)
        end
      else
        cElement.set_code(hRtnInfo, @hState[TSR_PRM_DO][TSR_PRM_CODE])
      end

      # GCOV����������
      if (@cConf.enable_gcov?() && @hState[TSR_PRM_DO][TSR_PRM_GCOV] == true)
        cElement.set_code(hRtnInfo, FNC_GCOV_TTG_C_PAUSE)
      end

    end

  end
end
