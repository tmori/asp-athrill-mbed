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
#  $Id: ObjectCommon.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#
require "common/bin/CommonModule.rb"
require "ttc/bin/class/TTCCommon.rb"

#=====================================================================
# TTCModule
#=====================================================================
module TTCModule
  #===================================================================
  # ������: ���֥������ȥ��饹���̥᥽�å�
  #===================================================================
  module ObjectCommon
    include CommonModule
    attr_accessor :aNilAttributes, :aSpecifiedAttributes

    #=================================================================
    # ������: ���֥���������Υޥ�����ִ�����
    #=================================================================
    def convert_macro()
      hMacro = @cConf.get_macro()
      @hState.each{|sAtr, val|
        @hState[sAtr] = calc_all_expr(@hState[sAtr], hMacro)
      }
    end

    #=================================================================
    # ��  ��: �����Х��б��Τ���ѥ�᡼�����Ѵ���¹Ԥ���
    #=================================================================
    def convert_global(hTable, hClassTable)
      check_class(Hash, hTable)       # �Ѵ�ɽ
      check_class(Hash, hClassTable)  # ���饹�ִ��б�ɽ

      # prcid��class
      if (@hState[TSR_PRM_PRCID].is_a?(String))
        sMacro = @hState[TSR_PRM_PRCID]
        # prcid
        @hState[TSR_PRM_PRCID] = convert_global_prcid(sMacro, hTable)
        # class
        if (!@hState[TSR_PRM_CLASS].nil?() && sMacro != @hState[TSR_PRM_PRCID])
          sClass = @hState[TSR_PRM_CLASS]
          @hState[TSR_PRM_CLASS] = hClassTable[sMacro][sClass][@hState[TSR_PRM_PRCID]]
        end
      end

      # actprc
      if (@hState[TSR_PRM_ACTPRC].is_a?(String))
        @hState[TSR_PRM_ACTPRC] = convert_global_prcid(@hState[TSR_PRM_ACTPRC], hTable)
      end

      # intno
      if (@hState[TSR_PRM_INTNO].is_a?(String))
        @hState[TSR_PRM_INTNO] = convert_global_intno(@hState[TSR_PRM_INTNO], hTable)
      end

      # inhno
      if (@hState[TSR_PRM_INHNO].is_a?(String))
        @hState[TSR_PRM_INHNO] = convert_global_inhno(@hState[TSR_PRM_INHNO], hTable)
      end

      # excno
      if (@hState[TSR_PRM_EXCNO].is_a?(String))
        @hState[TSR_PRM_EXCNO] = convert_global_excno(@hState[TSR_PRM_EXCNO], hTable)
      end
    end

    #=================================================================
    # ������: �����Х��ִ��о�°�������ƥޥ�����������Ƥ��뤫
    #=================================================================
    def is_global_attribute_all_macro?()
      # �����å�����°���ȡ��ޥ��������ɽ��
      hCheckAtr = {
        TSR_PRM_PRCID  => CFG_MCR_REX_PRCID,
        TSR_PRM_CLASS  => CFG_MCR_REX_CLASS,
        TSR_PRM_INTNO  => CFG_MCR_REX_INTNO,
        TSR_PRM_INHNO  => CFG_MCR_REX_INHNO,
        TSR_PRM_EXCNO  => CFG_MCR_REX_EXCNO
      }

      return hCheckAtr.all?(){|sAtr, cReg|
        (@hState[sAtr].nil?() || @hState[sAtr] =~ cReg)
      }  # [Bool]�����Х��ִ��о�°�������ƥޥ�����������Ƥ��뤫
    end

    #=================================================================
    # ��  ��: YAML���ؤΥѥ������ꤹ��
    #=================================================================
    def set_path(aPath)
      check_class(Array, aPath)  # �롼�Ȥ���Υѥ�

      @aPath = aPath
    end

    #=================================================================
    # ��  ��: ����ͤ��䴰����
    #=================================================================
    def complement_init_object_info()
      # �̾�ϲ��⤷�ʤ�
      # ɬ�פʥ��֥������Ȥϥ����С��饤��
    end

    #=================================================================
    # ������: �䴰��¹Ԥ���
    #=================================================================
    def complement(cPrevObj)
      # �������å��ϳƥ��֥������ȤΥ����ѡ����饹�Ǽ»ܤ��뤳��
      check_class(Object, cPrevObj)  # ľ���ξ��֤Υ��֥�������

      # ���ꤵ��Ƥ��ʤ�����䴰
      cPrevObj.hState.each{|sAtr, val|
        sRealAtr = get_real_attribute_name(sAtr)
        unless (is_specified?(sRealAtr))
          @hState[sAtr] = safe_dup(val)
        end
      }
    end

    #=================================================================
    # ������: ���䴰��λ��˼¹Ԥ������
    #=================================================================
    def complement_after()
      # �̾�ϲ��⤷�ʤ�
      # ɬ�פʥ��֥������Ȥϥ����С��饤��
    end

    #=================================================================
    # ������: �����ꥢ����¹Ԥ���
    #=================================================================
    def alias(hAlias)
      check_class(Hash, hAlias)   # �����ꥢ���Ѵ��ơ��֥�

      # ���֥�������ID
      @sObjectID = hAlias[@sObjectID]

      # °��
      @hState.each{|sAtr, val|
        if (val.is_a?(String))
          @hState[sAtr] = alias_replace(val, hAlias)
        end
      }
    end

    #=================================================================
    # ������: ���֥������ȤΥ����ꥢ���Ѵ��ơ��֥���֤�
    #=================================================================
    def get_alias(sTestID, nNum = nil)
      abort(ERR_MSG % [__FILE__, __LINE__])
    end

    #=================================================================
    # ��  ��: ���֥����������¸�ߤ����ѿ�̾�������֤�
    #=================================================================
    def get_variable_names()
      return []  # [Array]���֥����������¸�ߤ����ѿ�̾����
    end

    #=================================================================
    # ��  ��: �����ݻ���°��̾����TESRY��°��̾���������
    #=================================================================
    def get_real_attribute_name(sAtr)
      check_class(String, sAtr)  # �����ݻ���°��̾

      return sAtr  # [String]TESRY��°��̾
    end

    #=================================================================
    # ��  ��: Yaml�˵��Ҥ���Ƥ���ѥ�᡼���ꥹ�Ȥ�Ͽ����
    #=================================================================
    def set_specified_attribute(hObjectInfo)
      check_class(Hash, hObjectInfo, true)  # ���֥������Ⱦ���

      if (hObjectInfo.nil?())
        @aSpecifiedAttributes = []
      else
        @aSpecifiedAttributes = hObjectInfo.keys()
        @aSpecifiedAttributes.delete(TSR_PRM_TYPE)
      end
    end

    #=================================================================
    # ��  ��: Nil�Υѥ�᡼���ꥹ�Ȥ�Ͽ����
    #=================================================================
    def set_nil_attribute()
      @aNilAttributes = []
      @hState.each{|sAtr, val|
        if (val.nil?())
          @aNilAttributes.push(sAtr)
        end
      }
    end

    #=================================================================
    # ������: °�������å�(����°������ꤷ����������å�)
    #=================================================================
    def pre_attribute_check(hObjectInfo, aPath, bIsPre)
      check_class(Hash, hObjectInfo)  # ���֥������Ⱦ���
      check_class(Array, aPath)       # �롼�Ȥ���Υѥ�
      check_class(Bool, bIsPre)       # pre_condition�⤫

      aErrors = []
      # ���֥������ȥ����פ��б�����°����������
      hAtrDefList = get_attribute_list()

      ### �����ǽ��°����
      aAtrs = hObjectInfo.keys()
      begin
        aAtrs.delete(TSR_PRM_TYPE)
        check_defined_attribute(aAtrs, hAtrDefList.keys(), aPath)
      rescue TTCMultiError
        aErrors.concat($!.aErrors)
      end

      ### T1_023: pre_condition�ǻ���ɬ�ܤ�°�������ꤵ��Ƥ��ʤ�
      if (bIsPre == true)
        hAtrDefList.each{|sAtr, aDef|
          if (aDef[0] == true)
            unless (hObjectInfo.has_key?(sAtr))
              sErr = sprintf("T1_023: " + ERR_REQUIRED_KEY, sAtr)
              aErrors.push(YamlError.new(sErr, aPath))
            end
          end
        }
      ### T1_024: pre_condition�Τߤǻ����ǽ��°�������ꤵ��Ƥ���
      else
        hAtrDefList.each{|sAtr, aDef|
          if (aDef[1] == true)
            if (hObjectInfo.has_key?(sAtr))
              sErr = sprintf("T1_024: " + ERR_ONLY_PRE_ATR, sAtr)
              aErrors.push(YamlError.new(sErr, aPath))
            end
          end
        }
      end

      check_error(aErrors)
    end

    #=================================================================
    # ��  ��: ���֥������Ȥ�°��������������
    #=================================================================
    def get_attribute_list()
      # �ץ�ե�������б�����°��������������
      cConf    = Config.new()
      hAtrList = {}
      if (cConf.is_asp?())
        hAtrList = GRP_DEF_OBJECT_ASP
      elsif (cConf.is_fmp?())
        hAtrList = GRP_DEF_OBJECT_FMP
      end

      # ���֥������ȥ����פ��б�����°����������
      if (hAtrList.has_key?(@sObjectType))
        return hAtrList[@sObjectType]  # [Hash]���֥������Ȥ�°���������
      else
        abort(ERR_MSG % [__FILE__, __LINE__])
      end
    end

    #=================================================================
    # ��  ��: ���֥������Ȥ����Ƥ�YAML���֥������Ȥ��Ѵ������֤�
    #=================================================================
    def to_yaml(bIsPre = false)
      check_class(Bool, bIsPre)  # pre_condition��

      hYaml = {}
      # pre�ξ��type°������Ϳ
      if (bIsPre == true)
        hYaml[TSR_PRM_TYPE] = @sObjectType
      end
      # �ݻ����Ƥ������������
      @hState.each{|sAtr, val|
        sRealAtr = get_real_attribute_name(sAtr)
        if (!val.nil?() || is_specified?(sRealAtr))
          hYaml[sRealAtr] = safe_dup(val)
        end
      }

      return hYaml  # [Hash]YAML���֥�������
    end

    #=================================================================
    # ��  ��: ���ꤵ�줿°����YAML��ǵ��Ҥ���Ƥ��뤫���֤�
    #=================================================================
    def is_specified?(sAtr)
      check_class(String, sAtr, true)  # °��̾

      return @aSpecifiedAttributes.include?(sAtr)  # [Bool]���ꤵ�줿°����YAML��ǵ��Ҥ���Ƥ��뤫
    end

    #=================================================================
    # ������: °�������å�
    #=================================================================
    def attribute_check()
      abort(ERR_MSG % [__FILE__, __LINE__])
    end

    #=================================================================
    # ��  ��: ���֥������ȥ����å�
    #=================================================================
    def object_check(aPath, bIsPre = false)
      abort(ERR_MSG % [__FILE__, __LINE__])
    end
  end
end
