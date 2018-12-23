#!ruby -Ke
#
#  TTG
#      TOPPERS Test Generator
#
#  Copyright (C) 2009-2012 by Center for Embedded Computing Systems
#              Graduate School of Information Science, Nagoya Univ., JAPAN
#  Copyright (C) 2010-2011 by Graduate School of Information Science,
#                             Aichi Prefectural Univ., JAPAN
#  Copyright (C) 2012 by FUJISOFT INCORPORATED
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
#  $Id: Variable.rb 6 2012-09-03 11:06:01Z nces-shigihara $
#
require "common/bin/CommonModule.rb"
require "ttc/bin/class/TTCCommon.rb"
require "common/bin/IMCodeElement.rb"
require "ttc/bin/process_unit/Variable.rb"

#=====================================================================
# CommonModule
#=====================================================================
module CommonModule
  #===================================================================
  # ���饹̾: Variable
  # ��    ��: variable�ξ����������륯�饹
  #===================================================================
  class Variable
    include CommonModule
    include TTCModule
    include TTCModule::ObjectCommon

    attr_accessor :sVarName, :sType, :snValue, :hMember, :aPath

    #=================================================================
    # ��  ��: variable�ν����
    #=================================================================
    def initialize(sVarName, hVarInfo, aPath)
      check_class(Object, sVarName)        # �ѿ�̾(T2_001�ǥ����å���Ԥ�)
      check_class(Object, hVarInfo, true)  # �ѿ�������
      check_class(Array, aPath)            # �롼�Ȥ���Υѥ�

      @sVarName = sVarName    # �ѿ�̾
      @sType    = nil         # ��
      @snValue  = nil         # ��
      @hMember  = nil         # ��¤�ΤΥ���
      @aPath    = aPath + [@sVarName]

      @cConf = Config.new()

      store_var_info(hVarInfo)
    end

    #=================================================================
    # ��  ��: �ƥ��ȥ��ʥꥪ�̤�variable�˥ǡ���������
    #=================================================================
    def store_var_info(hVarInfo)
      check_class(Object, hVarInfo, true)  # �ѿ�������

      set_specified_attribute(hVarInfo)
      if (hVarInfo.is_a?(Hash))
        # ��¤�ΤΥ��Ф�����ж��ϥå���ǽ����
        hVarInfo.each_key{|sKey|
          unless ((sKey == TSR_PRM_VAR_TYPE) || (sKey == TSR_PRM_VAR_VALUE))
            @hMember = {}
          end
        }

        hVarInfo.each{|atr, val|
          case atr
          when TSR_PRM_VAR_TYPE
            @sType = val
          when TSR_PRM_VAR_VALUE
            @snValue = val
          else
            @hMember[atr] = val
          end
        }
      end
    end

    #=================================================================
    # ������: �����Х�/�������ѿ�����ѥ���������
    #=================================================================
    def gc_global_local_var(cElement, sObjectID)
      check_class(IMCodeElement, cElement) # �������
      check_class(String, sObjectID)       # ���֥�������ID

      # �����Х��ѿ�
      # (��å������ϰۤʤ륿�����������������ǽ�������뤿�ᥰ���Х��ѿ��Ȥ���)
      if (GRP_GLOBAL_TYPE.include?(@sType))
        # ��¤�ΤǤʤ����
        if (@hMember.nil?())
          cElement.set_global_var(@sVarName, @sType, @snValue)
        # ��¤�Τξ��(�������ѿ������)
        else
          sInitStr = make_initial_str()
          cElement.set_global_var(@sVarName, @sType, sInitStr)
        end

      # �������ѿ�
      else
        # ��¤�ΤǤʤ����
        if (@hMember.nil?())
          cElement.set_local_var(sObjectID, @sVarName, @sType, @snValue)
        # ��¤�Τξ��(�������ѿ������)
        else
          sInitStr = make_initial_str()
          cElement.set_local_var(sObjectID, @sVarName, @sType, sInitStr)
        end
      end
    end

    #=================================================================
    # ������: ��¤�ν������ʸ������֤�
    #=================================================================
    def make_initial_str()
      # �������Ƥ��ʤ���¤�Τη��ξ�票�顼
      if (!STR_INITIAL_INFO.has_key?(@sType))
        abort(ERR_MSG % [__FILE__, __LINE__])
      end

      sInitStr = "{"
      STR_INITIAL_INFO[@sType].each{|aStructInfo|
        # ASP�ξ�硤����Υ����ѿ����������
        if (@cConf.is_asp?())
          if ((aStructInfo[0] == STR_PRCID) || (aStructInfo[0] == STR_ACTPRC))
            next
          end
        end

        # ����ͤ����ꤵ��Ƥ�����
        if (@hMember.has_key?(aStructInfo[0]))
          sInitStr.concat(" #{@hMember[aStructInfo[0]]},")
        # ����ͤ����ꤵ��Ƥ��ʤ����
        else
          sInitStr.concat(" #{aStructInfo[2]},")
        end
      }
      sInitStr.chop!()
      sInitStr.concat(" }")

      return sInitStr # [String]��¤�ν������ʸ����
    end

    #=================================================================
    # ������: �������ѿ�����ѥ���������
    #=================================================================
    def gc_assert_value(cElement, hProcUnitInfo)
      check_class(IMCodeElement, cElement) # �������
      check_class(Hash, hProcUnitInfo)     # ����ñ�̾���

      # �ѿ����ͤ����ꤵ��Ƥ�����
      if (@hMember.nil?() && !@snValue.nil?())
        cElement.set_assert(hProcUnitInfo, @sVarName, @snValue)
      # ��¤�Τ����ꤵ��Ƥ�����
      elsif (!@hMember.nil?())
        @hMember.each{|name, val|
          cElement.set_assert(hProcUnitInfo, "#{@sVarName}.#{name}", val)
        }
      end
    end

  end
end
